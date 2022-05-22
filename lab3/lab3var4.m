QueueCapacity = 3; %длинна очереди
ServiceTime = 1/6; %время обслуживания одного клиента
TimeStep = 10; %разница во времени работы агенства (в часах) 
%между разными итерациями моделирования
n = 10; %количество итераций

waittime=zeros(n,1);
TimeArr=zeros(n,1);
Time = TimeStep;
TimeArr(1) = Time;
for k=1:n,
    TimeArr(k) = Time;
    sim('trenl');
    wait = simout; 
    waittime(k) = mean(wait);
    Time = Time+TimeStep;
end;

y=zeros(n,1);
for j=1:n,
    y(j) = 1/60*5;
end;

figure;
plot(TimeArr, y),
hold on,
plot(TimeArr, waittime),
ylim([0.05,0.1]),
xlabel('Время работы агенства'),
ylabel('Ожидание (в часах)'),
title('Время ожидания клиента в очереди'),
grid on,
hold off;

Time = 10000;
sim('trenl');
%Сколько звонков за время Time может быть обработано
count = simout1(length(simout1)); 
QueueCapacity = 30*Time;
sim('trenl');
%Сколько звонков потенциально может поступить
count2 = simout2(length(simout2)); 
fprintf("Относительная пропускная способность: %f \n", count/count2)
fprintf("Абсолютная пропускная способность: %f в час \n", count/count2*25)

QueueCapacity = 3;
