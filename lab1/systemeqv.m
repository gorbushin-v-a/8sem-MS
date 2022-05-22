function u = systemeqv(b,c)
     product=1;
     for i=1:c
           product=product*rand;
     end
     u=(-b)*log(product);
 return;