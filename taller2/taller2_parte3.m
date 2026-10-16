clear; clc; close all;
G  = tf(3, [1 2 3]);
Gd = tf(3, [1 2 3], 'InputDelay', 2);

% ================= T8: Senal propia por tramos =================
% 0-5 s   : 0
% 5-15 s  : rampa ascendente 0 -> 8
% 15-30 s : escalon de subida a 14
% 30-40 s : escalon de bajada a 6
% 40-50 s : rampa descendente 6 -> 0
t = 0:0.01:50;
u = zeros(size(t));

idx = (t >= 5 & t < 15);
u(idx) = (t(idx) - 5) * 0.8;              % rampa ascendente 0->8

idx = (t >= 15 & t < 30);
u(idx) = 14;                               % escalon de subida

idx = (t >= 30 & t < 40);
u(idx) = 6;                                % escalon de bajada

idx = (t >= 40 & t <= 50);
u(idx) = 6 - (t(idx) - 40) * 0.6;          % rampa descendente 6->0

figure('Name', 'T8 - Senal propia');
subplot(2,1,1); plot(t, u, 'LineWidth', 1.5); grid on;
xlabel('Tiempo [s]'); ylabel('u(t)'); title('Senal propia por tramos (T8)');

% ---- Respuesta de Gd(s) con lsim ----
[y, t] = lsim(Gd, u, t);
[ymax, k] = max(y);
tmax = t(k);
yfinal = y(end);

% inicio de la respuesta: primer instante en que u(t) deja de ser 0, mas el retardo
k_u0 = find(u > 1e-6, 1);
tinicio = t(k_u0) + 2;   % 2 = retardo de Gd(s)

subplot(2,1,2);
plot(t, u, 'Color', [.6 .6 .6]); hold on;
plot(t, y, 'LineWidth', 1.5); grid on;
plot(tmax, ymax, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
xline(tinicio, ':r');
plot(tinicio, 0, 'ro', 'MarkerFaceColor', 'r');
text(tmax+0.3, ymax, sprintf('y_{max}=%.3f\nt=%.2fs', ymax, tmax), 'FontSize', 8);
text(tinicio+0.3, 0.05*max(y), sprintf('inicio de la respuesta G_d(s)\nt=%.2fs', tinicio), ...
    'FontSize', 8, 'Color', 'r');
xlabel('Tiempo [s]'); ylabel('Amplitud');
legend('u(t)', 'y(t)'); title('Respuesta de G(s)e^{-2s}');

fprintf('Senal propia T8: y_max = %.3f en t = %.2f s ; y_final = %.3f ; t_inicio = %.2f s\n', ...
    ymax, tmax, yfinal, tinicio);

saveas(gcf, 'T2_propia.png');
