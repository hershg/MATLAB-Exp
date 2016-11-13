function A = createEnvelope(t)

% Create amplitude envelope
A = 2*exp(-1.5*t).*sin(2*pi*0.65*t);
