% T9_barrido.m
% Barrido de Kp, Ki y Kd sobre T8_pid (solver fijo, ECM con trapz)
modelo = 'taller3_parte3';
configs = [ 5 10 0;        % P: Ki = 2Kp
           10 20 0;
           20 40 0;
           10  0 0;        % I: Ki = 0, 10, 40 con Kp = 10
           10 10 0;
           10 40 0;
           10 20 0.05;     % D
           10 20 0.1];

fprintf('%4s %4s %5s | %8s %8s %9s\n', 'Kp','Ki','Kd','ECM','|u|max','sobrep%');
for i = 1:size(configs,1)
    Kp = configs(i,1);  Ki = configs(i,2);  Kd = configs(i,3);
    assignin('base','Kp',Kp);  assignin('base','Ki',Ki);  assignin('base','Kd',Kd);
    out = sim(modelo);

    t = out.r_out.Time;  r = out.r_out.Data;
    y = out.y_out.Data;  u = out.u_out.Data;
    e = r - y;

    ECM   = trapz(t, e.^2) / (t(end) - t(1));
    umax  = max(abs(u));
    sobre = max(0, 100*(max(y) - 1));     % sobrepaso respecto a r = 1

    fprintf('%4g %4g %5g | %8.5f %8.2f %9.2f\n', Kp, Ki, Kd, ECM, umax, sobre);
end
