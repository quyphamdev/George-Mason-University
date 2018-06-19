while(true)
    %--------------------------------------------
    % Question 1
    %--------------------------------------------
    while(true)
        display('Choose from the following menu:');
        display('---Enter complex number in polar form (1)');
        display('---Enter complex number in rectangular form (2)');
        display('---End program(0)');
        res = input('Type in your choice here:');
        if(res == 0)||(res == 1)||(res == 2)
            break  % user entered a correct choice(between 0-2), jump out of while loop
        else
            % user entered a wrong choice, display error and display menu
            % option again
            display('Your input has to be between 0-2');
        end
    end
    
    %--------------------------------------------
    % Question 2
    %--------------------------------------------
    % user wanted to quit, end the program
    if(res == 0)
        return; % exit
        
    %--------------------------------------------
    % Question 3
    %--------------------------------------------
    % user wanted to enter a complex number. Interprete his choice...
    elseif(res == 1) % complex number in polar form              
        polar_res = 0;
        while((polar_res ~= 1)&&(polar_res ~= 2)) % keep looping until user enters a right input            
            disp('Enter phase in:');        
            disp('--Degrees(1)');        
            disp('--Radian(2)');        
            polar_res = input('Choice (1 or 2): ');        
            if(polar_res ~= 1)&&(polar_res ~= 2) % the input is not 1 or 2, ask user enter his choice again        
                disp('Your input need to be only 1 or 2. Try again...');          
            end
        end

        disp('First complex number c1');
        phase = input('Enter phase: ');
        if(polar_res == 1)  % phase in degree
            phase = phase*pi/180;   % convert to radian
        else % phase in radian
            % do nothing
        end
        m = -1;
        while(m < 0)
            m = input('Enter the magnitude (positive number): ');        
        end
        x1 = m*cos(phase);
        y1 = m*sin(phase);
        c1 = x1 + i*y1;
        disp(['C1 = ',num2str(x1),' + j',num2str(y1)]);

        disp('Second complex number c2');
        c2 = c1;
        while(c1 == c2)
            phase = input('Enter phase: ');
            if(polar_res == 1)  % phase in degree
                phase = phase*pi/180;   % convert to radian
            else % phase in radian
                % do nothing
            end
            m = -1;
            while(m < 0) % magnitude must be positive
                m = input('Enter the magnitude (positive number): ');        
            end
            x2 = m*cos(phase);
            y2 = m*sin(phase);
            c2 = x2 + i*y2;
            if(c2 == c1) 
                disp('C2 = C1. Please enter a different number');
            end        
        end
        disp(['C2 = ',num2str(x2),' + j',num2str(y2)]);
    elseif(res == 2) % complex number in rectangular form
        disp('First complex number C1 = x + jy');
        x1 = input('Enter the real part x = ');
        y1 = input('Enter the imaginary part y = ');
        c1 = x1 + i*y1;
        disp(['C1 = ',num2str(x1),' + j',num2str(y1)]);
        disp('Second complex number C2 = x + jy');
        c2 = c1;
        while(c2 == c1) % c2 and c1 have to be dif. otherwise keep prompting for dif input
            x2 = input('Enter the real part x = ');
            y2 = input('Enter the imaginary part y = ');
            c2 = x2 + i*y2;
            if(c2 == c1)
                disp('C2 = C1. Please enter a different number');
            end
        end
        disp(['C2 = ',num2str(x2),' + j',num2str(y2)]);
        disp('How do you want to show the phase in polar form ?');
        disp('--Degrees (1)');
        disp('--Radians (2)');
        rect_res = 0;    
        while(rect_res ~= 1)&&(rect_res ~= 2)
            rect_res = input('Choice(1,2)?: ');        
        end
        % calculate the magnitudes
        m1 = sqrt(x1*x1+y1*y1);
        m2 = sqrt(x2*x2+y2*y2);
        % and the phases
        phase1 = atan(y1/x1);
        phase2 = atan(y2/x2);
        if(rect_res == 1)   % display phase in degree
            phase1 = phase1*180/pi; % convert radian to degree
            phase2 = phase2*180/pi;
            disp(['C1 has magnitude ',num2str(m1),' and phase ',num2str(phase1),' degree.']);
            disp(['C2 has magnitude ',num2str(m2),' and phase ',num2str(phase2),' degree.']);
        else % display phase in radian
            disp(['C1 has magnitude ',num2str(m1),' and phase ',num2str(phase1),' radian.']);
            disp(['C2 has magnitude ',num2str(m2),' and phase ',num2str(phase2),' radian.']);
        end
    end
    %--------------------------------------------
    % Question 4
    %--------------------------------------------
    c3 = c1 + c2;
    %--------------------------------------------
    % Question 5
    %--------------------------------------------
    figure(1);
    hold on;    % plot all 3 complex numbers on the same plot
    t = 0:0.01:1;
    plot(real(c1)*t,imag(c1)*t,'ro'); % red circle
    plot(real(c2)*t,imag(c2)*t,'bs'); % blue square
    plot(real(c3)*t,imag(c3)*t,'kd'); % black diamon
    xlabel('Real');
    ylabel('Imaginary');
    title('Complex Numbers');
    hold off;
    %--------------------------------------------
    % Question 6
    %--------------------------------------------   
    %c3 = 0.1 + i;
    %nn = 0:1:100;
    nn = 0:1:20;
    y = c3.^nn;
    figure(2);
    plot(y);
    xlabel('Real');
    ylabel('Imaginary');
    grid;
    % The result is a clock-wise whirl figure which is formed by vectors. The end of the
    % previous vector is the start of the next one and the next one , and so on out of the center.
    % The turning angles are the same.
    % The vector's size keeps increasing after another.

    %--------------------------------------------
    % Question 7
    %--------------------------------------------
end