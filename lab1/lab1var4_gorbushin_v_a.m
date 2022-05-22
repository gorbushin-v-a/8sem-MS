clear all; 
nf=2; 
minf=[1 2]; 
maxf=[6 6]; 
%формирование дробного двухуровневого плана эксперимента
%для учета взаимодействий
fracfact('a b ab' ); 
N=2^nf; 
fracplan=ans 
fictfact=ones(N,1); 
X=[fictfact ans]' 
fraceks=zeros(N,nf); 
for i=1:nf, 
for j=1:N, 
fraceks(j,i)=minf(i)+(fracplan(j,i)+1)*(maxf(i)-minf(i))/2; 
end; 
end; 
fraceks

%тактическое планирование эксперимента
%задание доверительного интервала и уровня значимости
d_sigma=0.12;
alpha=0.06;
%определение t-критического
tkr_alpha=trnd(1-alpha/2);
%цикл по совокупности экспериментов стратегического плана
for j=1:N,
    b=fraceks(j,1); 
    c=fraceks(j,2);
    %определение требуемого числа испытаний
    u=[];
    u(1) = systemeqv(b, c);
    u(2) = systemeqv(b, c);
    n = 2;
    D_tilda = std(u) ^ 2;
    %число испытаний на текущем шаге
    NE = round(tkr_alpha^2 * D_tilda / d_sigma ^ 2)
    %цикл статистических испытаний
    while n <= NE || n<30
        %имитация функционирования системы
        n = n + 1;
        u(n) = systemeqv(b, c);
        D_tilda = std(u) ^ 2;
        %выполняется перерасчёт числа испытаний для k-го эксперимента
        NE = round(tkr_alpha^2 * D_tilda / d_sigma ^ 2);
    end;
    %оценка параметров (реакции) по выборке наблюдений
    mx=mean(u);
    Y(j)=mx;
    %figure;
    %hist(u,12);
end;

%определение коэффициентов регрессии
C1=X*X'; 
b_=inv(C1)*X*Y' 

%формирование зависимости реакции системы на множестве
%реальных значений факторов
B=minf(1):0.1:maxf(1); 
C=minf(2):0.1:maxf(2); 
[k N1]=size(B); 
[k N2]=size(C); 
for i=1:N1, 
 for j=1:N2, 
 bn(i)=2*(B(i)-minf(1))/(maxf(1)-minf(1))-1; 
 cn(j)=2*(C(j)-minf(2))/(maxf(2)-minf(2))-1; 
 %экспериментальная поверхность реакции
 Yc(j,i)=b_(1)+bn(i)*b_(2)+cn(j)*b_(3)+bn(i)*cn(j)*b_(4); 
 %теоретическая поверхность реакции
 Yo(j,i)=B(i)*C(j);
end; 
end; 
% отображение зависимостей в трехмерной графике 
[x,y]=meshgrid(B,C); 
figure; 
subplot(1,2,1),plot3(x,y,Yc), 
xlabel('fact b'), 
ylabel('fact c'), 
zlabel('Yc'), 
title('Экспериментальная'), 
grid on, 
subplot(1,2,2),plot3(x,y,Yo), 
xlabel('fact b'), 
ylabel('fact c'), 
zlabel('Yo'), 
title('Теоретическая'), 
grid on;