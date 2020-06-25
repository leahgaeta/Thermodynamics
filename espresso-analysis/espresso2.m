c_al = 0.12;
c_w = 1;
time = 0:0.5:600;
t_room = 70;
hA = 0.5;
k = 5 * 10^(-9);
m_pot = .288;
m_w = .5318;
Q_loss = 0;
y = [];
y(1) = 70;
Q_in = 1000/3600;
count = 0;
for i = 1:length(time)-1
    Q_net = Q_in - Q_loss;
    y(i+1) = (Q_net/(m_pot*c_al + m_w*c_w))*.5 + y(i);
    Q_loss = (hA * (y(i+1) - t_room) + k * ((y(i+1) + 460).^4 - (t_room + 460).^4))/3600;
    if y(i+1) > 212.33
        y(i+1) = 212.33;
        count = count + 1;
    end
end
count = length(time)-count;
boiling_temp = ones(1,length(time)).*212;
plot(time, boiling_temp, 'k-.')
hold on
plot(time(1:end),y,'b.')
title('Q_i_n = 1000 Btu/hr')
legend('Boiling Point at P_a_t_m', 'Coffee & Pot Temperature', 'Location', "best")
xlabel('Time (s)')
ylabel('Temperature (F)')
axis([0 600 50 230])

p = polyfit(time(1:count),y(1:count),4);
f1 = polyval(p,time(1:count));
figure 
plot(time(1:end),y,'b-')
hold on
plot(time(1:count),f1,'k.')

final_time = time(count)/3600 % hrs
Q_n = m_w*c_w*(212.33-70) + (m_w*0.25/778.17) + (hA * (212.33 - 70) + k * ((212.33 + 460).^4 - (70 + 460).^4))*final_time
Q_n = (m_w*c_w + m_pot*c_al)*(212.33-70) + (m_w*0.25/778.17) + (hA * (212.33 - 70) + k * ((212.33 + 460).^4 - (70 + 460).^4))*final_time
Q_out = 0;
Q_net = Q_in - Q_out;
y(count) = (Q_net/(m_pot*c_al + m_w*c_w))*.5 + y(count-1);
Q_loss = (hA * (y(count) - t_room) + k * ((y(count) + 460).^4 - (t_room + 460).^4))/3600;
Q_net = (Q_in - Q_loss)*final_time + (m_pot*c_al + m_w*c_w)*32.3*.25*final_time*60;