% T6_metricas.m
% Simula T5_histeresis para h = 0.05, 0.1 y 0.2 y calcula ECM, fsw, rango y |u|max
modelo = 'taller3_parte2';
U  = 3;                          % amplitud del relé: +U / -U
hs = [0.05 0.1 0.2];
assignin('base', 'U', U);

for i = 1:numel(hs)
    h = hs(i);
    assignin('base', 'h', h);    % el Relay lee h y -h del workspace
    out = sim(modelo);

    t = out.u_out.Time;
    r = out.r_out.Data;
    y = out.y_out.Data;
    u = out.u_out.Data;

    % 1) ECM sobre toda la simulación (0–10 s)
    ECM = mean((r - y).^2);

    % 2) fsw medida en la ventana de régimen 1 <= t < 2 s
    v   = (t >= 1) & (t < 2);
    fsw = sum(abs(diff(sign(u(v)))) > 0) / 2;

    % 3) Esfuerzo de control
    umax = max(abs(u));

    % 4) Rango de y en régimen
    yrango = [min(y(v)) max(y(v))];

    % 5) fsw calculada con la fórmula de Åström (lámina 13)
    tup   = 0.5*log((U - 2*(1-h)) / (U - 2*(1+h)));
    tdn   = 0.5*log((U + 2*(1+h)) / (U + 2*(1-h)));
    fsw_f = 1 / (tup + tdn);

    fprintf('h = %.2f | ECM = %.4f | fsw = %5.2f Hz | |u|max = %.2f | rango y = [%.3f, %.3f]\n', ...
        h, ECM, fsw, umax, yrango(1), yrango(2));
end