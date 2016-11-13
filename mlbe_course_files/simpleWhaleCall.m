function [call,t] = simpleWhaleCall(f0)

% Create the time base for the signal
fs = 4000;
t = 0:(1/fs):1.5;

% Create the harmonics
y1 = sin(2*pi*f0*t);
y2 = sin(2*pi*2*f0*t);
y3 = sin(2*pi*3*f0*t);
y0 = y1 + y2 + y3;

% Create the envelope
A = createEnvelope(t);

% Create the call
call = A.*y0;

% Plot the model call
figure
plot(t,call)
