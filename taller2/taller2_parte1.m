clear; clc; close all;

G  = tf(3, [1 2 3]);
Gd = tf(3, [1 2 3], 'InputDelay', 2);
TAU = 2;
t = 0:0.01:12;

[y_imp,   t] = impulse(G,  t);
[y_stp,   t] = step(G,     t);
[y_impd,  t] = impulse(Gd, t);
[y_stpd,  t] = step(Gd,    t);

% ---- Tabla 2.2: polos y valor final de G(s) ----
p = pole(G);
yfinal_teo  = dcgain(G);
yfinal_sim  = y_stp(end);
yfinal_amp5 = dcgain(G) * 5;

fprintf('%-32s%-16s%-20s\n', 'Magnitud', 'Valor', 'Comando usado');
fprintf('%s\n', repmat('-', 1, 70));
fprintf('%-32s%-16.4g%-20s\n', 'Polo p1', p(1), 'pole(G)');
fprintf('%-32s%-16.4g%-20s\n', 'Polo p2', p(2), 'pole(G)');
fprintf('%-32s%-16.3f%-20s\n\n', 'y(infinito), escalon unitario', yfinal_sim, 'dcgain(G), y(end)');
fprintf('%-34s%-16.3f%-20s\n', 'y(infinito), escalon amplitud 5', yfinal_amp5, 'dcgain(G)*5');

datos    = {y_imp, y_stp, y_impd, y_stpd};
titulos  = {'Respuesta al impulso de G(s)', 'Respuesta al escalon de G(s)', ...
            'Respuesta al impulso de Gd(s)', 'Respuesta al escalon de Gd(s)'};
con_retardo = [false, false, true, true];

% ---- Ventana 1: las cuatro respuestas ----
figure('Name', 'Cuatro respuestas');
for i = 1:4
    subplot(2,2,i);
    plot(t, datos{i}, 'LineWidth', 1.5); grid on;
    title(titulos{i}); xlabel('Tiempo [s]'); ylabel('y(t)');
end

% ---- Calculo de maximo, inicio y valor final ----
res = struct('ymax', {}, 'tmax', {}, 'tinicio', {}, 'yfinal', {});
for i = 1:4
    y = datos{i};
    [~, k] = max(abs(y));
    ymax = y(k);
    tmax = t(k);

    if con_retardo(i)
        tinicio = TAU;
    else
        tinicio = 0;
    end

    yfinal = y(end);
    res(i) = struct('ymax', ymax, 'tmax', tmax, 'tinicio', tinicio, 'yfinal', yfinal);
end

% ---- Ventana 2: las cuatro respuestas con y_max e inicio marcados ----
figure('Name', 'Maximo e inicio');
for i = 1:4
    subplot(2,2,i);
    plot(t, datos{i}, 'LineWidth', 1.5); hold on; grid on;
    plot(res(i).tmax, res(i).ymax, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
    xline(res(i).tinicio, ':r');
    text(res(i).tmax + 0.2, res(i).ymax, ...
        sprintf('y_{max}=%.3f\nt=%.2fs', res(i).ymax, res(i).tmax), 'FontSize', 8);
    text(res(i).tinicio + 0.1, 0.05, ...
        sprintf('t_{inicio}=%.2fs', res(i).tinicio), 'FontSize', 8, 'Color', 'r');
    title(titulos{i}); xlabel('Tiempo [s]'); ylabel('y(t)');
end

% ---- Tabla 2.3 en terminal ----
fprintf('%-3s%-22s%-14s%-12s%-14s%-12s\n', '#', 'Respuesta', 'Val. max', 't_max[s]', 't_inicio[s]', 'Val. final');
for i = 1:4
    fprintf('%-3d%-22s%-14.3f%-12.2f%-14.2f%-12.3f\n', i, titulos{i}, ...
        res(i).ymax, res(i).tmax, res(i).tinicio, res(i).yfinal);
end

% ---- Mapa de polos de G(s) ----
figure('Name', 'Polos de G(s)');
hold on; grid on;

% Ejes del plano cartesiano
xl = [min(real(p))-1, max(real(p))+1];
yl = [-max(abs(imag(p)))-1, max(abs(imag(p)))+1];
xl(1) = min(xl(1), -0.5); xl(2) = max(xl(2), 0.5);
plot(xl, [0 0], 'Color', 'w');   % eje real
plot([0 0], yl, 'Color', 'w');   % eje imaginario

% Polos
plot(real(p), imag(p), 'rx', 'MarkerSize', 12, 'LineWidth', 2);

for i = 1:numel(p)
    text(real(p(i)) + 0.1, imag(p(i)) + 0.1, ...
        sprintf('p_%d = %.3f %+.3fj', i, real(p(i)), imag(p(i))), 'FontSize', 9);
end

xlim(xl); ylim(yl);
xlabel('Parte real (\sigma)'); ylabel('Parte imaginaria (j\omega)');
title('Polos de G(s) en el plano s');
axis equal;
