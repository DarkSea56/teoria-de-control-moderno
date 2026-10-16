clear; clc; close all;
G  = tf(3, [1 2 3]);
Gd = tf(3, [1 2 3], 'InputDelay', 2);

% ================= T5: Senal arbitraria 1 =================
t = 0:0.01:30;
u = 5*(t >= 10) + 5*(t >= 20);

% ================= T6: Respuesta de Gd(s) a la senal 1 =================
[y, t] = lsim(Gd, u, t);
[ymax1, k1] = max(y);
tmax1 = t(k1);
k0_1 = find(y > 1e-3, 1);
tinicio1 = t(k0_1);
yfinal1 = y(end);

figure('Name', 'T2 arbitraria 1');
subplot(2,1,1); plot(t, u, '--', 'LineWidth', 1.5); grid on;
xlabel('Tiempo [s]'); ylabel('u(t)'); ylim([0 11]); title('Senal arbitraria 1');

subplot(2,1,2);
plot(t, u, 'Color', [.6 .6 .6]); hold on;
plot(t, y, 'LineWidth', 1.5); grid on;
plot(tmax1, ymax1, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
xline(tinicio1, ':r');
plot(tinicio1, 0, 'ro', 'MarkerFaceColor', 'r');
text(tmax1+0.3, ymax1, sprintf('y_{max}=%.3f\nt=%.2fs', ymax1, tmax1), 'FontSize', 8);
text(tinicio1+0.3, 0.5, sprintf('t_{inicio}=%.2fs', tinicio1), 'FontSize', 8, 'Color', 'r');
xlabel('Tiempo [s]'); ylabel('Amplitud');
legend('u(t)', 'y(t)'); title('Respuesta de G(s)e^{-2s}');


% ================= T7: Senal arbitraria 2 (escalon + rampa) =================
t2 = 0:0.01:40;
u2 = zeros(size(t2));
u2(t2 >= 10 & t2 < 20) = 5;
idx = (t2 >= 20 & t2 < 30);
u2(idx) = 15 + (t2(idx) - 20);
u2(t2 >= 30) = 25;



% ================= T7: Respuesta de Gd(s) a la senal 2 =================
[y2, t2] = lsim(Gd, u2, t2);
[ymax2, k2] = max(y2);
tmax2 = t2(k2);
k0_2 = find(y2 > 1e-3, 1);
tinicio2 = t2(k0_2);
yfinal2 = y2(end);

figure('Name', 'T2 arbitraria 2');
subplot(2,1,1); plot(t2, u2, '--', 'LineWidth', 1.5); grid on;
xlabel('Tiempo [s]'); ylabel('u(t)'); title('Senal arbitraria 2');

subplot(2,1,2);
plot(t2, u2, 'Color', [.6 .6 .6]); hold on;
plot(t2, y2, 'LineWidth', 1.5); grid on;
plot(tmax2, ymax2, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
xline(tinicio2, ':r');
plot(tinicio2, 0, 'ro', 'MarkerFaceColor', 'r');
text(tmax2+0.3, ymax2, sprintf('y_{max}=%.3f\nt=%.2fs', ymax2, tmax2), 'FontSize', 8);
text(tinicio2+0.3, 1.0, sprintf('t_{inicio}=%.2fs', tinicio2), 'FontSize', 8, 'Color', 'r');
xlabel('Tiempo [s]'); ylabel('Amplitud');
legend('u(t)', 'y(t)'); title('Respuesta de G(s)e^{-2s}');



% ================= Tabla 2.4 (filas 5 y 6) =================
fprintf('\n%-3s%-22s%-12s%-12s%-14s%-12s\n', '#','Senal','Val. max','t_max[s]','t_inicio[s]','Val. final');
fprintf('%s\n', repmat('-', 1, 75));
fprintf('%-3d%-22s%-12.3f%-12.2f%-14.2f%-12.3f\n', 5, 'Senal arbitraria 1', ymax1, tmax1, tinicio1, yfinal1);
fprintf('%-3d%-22s%-12.3f%-12.2f%-14.2f%-12.3f\n', 6, 'Senal arbitraria 2', ymax2, tmax2, tinicio2, yfinal2);
