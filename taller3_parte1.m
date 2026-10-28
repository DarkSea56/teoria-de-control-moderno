% T3_metricas.m
% Simula T3_onoff para K = 1, 2 y 3 y calcula ECM, fsw y |u|max
modelo = 'taller3';
Ks = [1 2 3];
resultados = zeros(numel(Ks), 5);

for i = 1:numel(Ks)
    K = Ks(i);
    assignin('base', 'K', K);        % el bloque de ganancia lee K del workspace
    out = sim(modelo);

    t = out.u_out.Time;
    r = out.r_out.Data;
    y = out.y_out.Data;
    u = out.u_out.Data;

    % 1) ECM sobre toda la simulación (0–10 s)
    ECM = mean((r - y).^2);

    % 2) fsw en la ventana de régimen 1 <= t < 2 s
    v  = (t >= 1) & (t < 2);
    fsw = sum(abs(diff(sign(u(v)))) > 0) / 2;   % cambios de signo / 2; ventana de 1 s → Hz

    % 3) Esfuerzo de control
    umax = max(abs(u));

    % 4) Rango de oscilación de y en régimen
    rango = [min(y(v)) max(y(v))];

    resultados(i,:) = [K ECM fsw umax rango(2)-rango(1)];
    fprintf('K = %d | ECM = %.4f | fsw = %6.1f Hz | |u|max = %.2f | rango y = [%.3f, %.3f]\n', ...
            K, ECM, fsw, umax, rango(1), rango(2));
end