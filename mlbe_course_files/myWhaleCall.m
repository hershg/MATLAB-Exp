fs = 4000;
t = 0:1/fs:1.5;
f0 = 100;
y1 = sin(2*pi*f0*t);
y2 = sin(2*pi*2*f0*t);
y3 = sin(2*pi*3*f0*t);
y0 = y1+y2+y3
A = (2*exp(-1.5*t)).*sin(2*pi*0.65*t);
call = A.*y0;
soundsc(call,fs)
plot(t,call)