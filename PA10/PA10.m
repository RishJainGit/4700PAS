clear all;
close all;

x = 0;
xp = 0; 
v = 0;
F = 1;   
m = 1;  

dt = 1;
nt = 1000;  
np = 1;     
v = zeros(np,1);
x = zeros(np,1);
t = zeros(nt,1);

re = 0;      

figure;

subplot(3,1,1); hold on; grid on;
xlabel('Time');
ylabel('Position');
title('Position vs Time');
h_pos = plot(0,0,'b');        
h_pos_avg = yline(0, '--g', 'x_{ave}', 'LineWidth', 2); 

subplot(3,1,2); hold on; grid on;
xlabel('Time');
ylabel('Velocity');
title('Velocity vs Time');
h_vel = plot(0,0,'r');      
h_vel_avg = yline(0, '--g', 'V_{ave}', 'LineWidth', 2); 

subplot(3,1,3); hold on; grid on;
xlabel('Position');
ylabel('Velocity');
title('Velocity vs Position');
h_phase = plot(0,0,'k');    

for it = 2:nt
    t(it) = (it-1)*dt;
    
    a = F / m;
    v(it) = v(it-1) + a*dt;
    x(it) = x(it-1) + v(it)*dt;

    if rand < 0.05
        v(it) = re * v(it);
    end

    v_drift = mean(v(1:it));
    x_avg = mean(x(1:it));

    subplot(3,1,1);
    set(h_pos, 'XData', t(1:it), 'YData', x(1:it));
    set(h_pos_avg, 'Value', x_avg);

    subplot(3,1,2);
    set(h_vel, 'XData', t(1:it), 'YData', v(1:it));
    set(h_vel_avg, 'Value', v_drift);

    subplot(3,1,3);
    set(h_phase, 'XData', x(1:it), 'YData', v(1:it));

    sgtitle(['Drift Velocity = ' num2str(v_drift, '%.2f')]);
    drawnow;
end
