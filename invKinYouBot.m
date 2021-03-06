function ik_demo()
	clc;
	clear all;
	close all;
	
% 	figure('Toolbar', 'figure');
	ax = createStage([-6 10 -10 10 -2 12], [-24 41]);
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
%     set(ax, 'CameraUpVector', [1 0 0], 'CameraPosition', [12, 15, -3], 'CameraTarget', [1 0 5]);
	t_goal = triade(T_unity(), [], 4, 0.1);
%     createObject(transform(T_shift(-1, 0, 0), geoGeneric([0, -10 -5; 0 -10 15; 0 10 15; 0 10 -5], [1 2 3 4])), 'FaceColor', [0.9 0.9 0.9]);
	camlight();
	linkColors = {[.4 .4 .4], [1 1 1], [.5 1 .5], [.5 .5 1], [.5 1 1], [1 .5 .5]};
	
    % global varibles
    global max_angles min_angles d1 a1 a2 a3 d5
    
    max_angles = [169, 155, 151, 102.5, 167.5].*pi/180;
    min_angles = [-169, 0 -146, -102.5, -167.5].*pi/180;
    
	d1 = 14.7;
    a1 = 3.3;
    a2 = 15.5;
    a3 = 13.5;
    d5 = 21.75;
	robot = youBot(d1, a1, a2, a3, d5);
	robot.colorLinks(linkColors{1}, linkColors{2}, linkColors{3}, linkColors{4}, linkColors{5}, linkColors{6});
	robot.setTransparency(0.5);
    
	% controls for
	hArmConfig1 = uicontrol('Style', 'checkbox', 'String', 'k_arm1 = -1', 'Position', [5, 120, 215, 20], 'Callback', @updateFromSliders, 'Value', 0);
    hArmConfig3 = uicontrol('Style', 'checkbox', 'String', 'k_arm3 = -1', 'Position', [5, 100, 215, 20], 'Callback', @updateFromSliders, 'Value', 0);
	[hXSlider, hXText] = createSlider('X', 0, 80, -54.05, 54.05, -5, @updateFromSliders, [1 0 0]);
	[hYSlider, hYText] = createSlider('Y', 0, 60, -54.05, 54.05, 0, @updateFromSliders, [0 1 0]);
	[hZSlider, hZText] = createSlider('Z', 0, 40, -20.5, 65.45, 44, @updateFromSliders, [0 0 1]);
	[hPhiSlider, hPhiText] = createSlider('Pitch', 0, 20, -180, 180, 65, @updateFromSliders, [0 0 0]);
	[hGammaSlider, hGammaText] = createSlider('Roll', 0, 0, -150, 150, 0, @updateFromSliders, [0 0 0]);
	    
    updateFromSliders();	        

	function [hSlider, hText, hCaption] = createSlider(text, x, y, minimum, maximum, initialValue, callback, color)		
		hCaption = uicontrol('Style', 'text', 'Position', [x y 20 20], 'String', text, 'ForegroundColor', brighten(color, -0.5));
		hSlider = uicontrol('Style', 'slider', 'Position', [x + 20, y, 250, 20], 'Min', minimum, 'Max', maximum, 'Value', initialValue, 'Callback', callback);
		hText = uicontrol('Style', 'text', 'Position', [x + 270, y, 70, 20]);
	end

	function updateFromSliders(varargin)		
        px = get(hXSlider, 'Value');
        py = get(hYSlider, 'Value');
        pz = get(hZSlider, 'Value');
        phi = get(hPhiSlider, 'Value') * pi / 180;
        gamma = get(hGammaSlider, 'Value') * pi / 180;
        % show values
        set(hXText, 'String', sprintf('%0.2f cm', px));
        set(hYText, 'String', sprintf('%0.2f cm', py));
        set(hZText, 'String', sprintf('%0.1f cm', pz));
        set(hPhiText, 'String', sprintf('%0.0f°', phi * 180 / pi));
        set(hGammaText, 'String', sprintf('%0.0f°', gamma * 180 / pi));
    
        if get(hArmConfig1, 'Value') == 1
            k_Arm1 = -1;
        else k_Arm1 = 1;
        end
        
        if get(hArmConfig3, 'Value') == 1
            k_Arm3 = -1;
        else k_Arm3 = 1;
        end
        
        % calculate inverse kinematics
        jointarray = ik_Youbot(px,py,pz,phi,gamma,k_Arm1,k_Arm3);
        
        % solution valid check
        if numel(jointarray)~=5
            return
        end
%         solution_valid = isSolutionValid(jointarray);
%         
%         if solution_valid        
%             % apply 
%             robot.setJoins(jointarray(1), jointarray(2), jointarray(3), jointarray(4), jointarray(5));
%         else
%             errordlg('Inverse Kinematics solver failed!');
%         end
    robot.setJoins(jointarray(1), jointarray(2), jointarray(3), jointarray(4), jointarray(5));
    end

    function [theta] = ik_Youbot(gx,gy,gz,gphi,ggamma,jointconfig1,jointconfig3)
        % mark the goal pose
        T_B_T = T_shift(gx, gy, gz) * T_rot('xz', gphi, ggamma);  
		t_goal.place(T_B_T);
        
        % fügen Sie bitte hier die Berechnung für [j1 j2 j3 j4 j5] 
        
        ...
        
        
        theta =[j1, j2, j3, j4, j5];
    end
    
    function solution_valid = isSolutionValid(theta)
%         global max_angles min_angles
        
        solution_valid = true;
        if numel(theta)~=5
            solution_valid = false;
            return
        end
        for i=1:5
            if theta(i)<min_angles(i) ||theta(i)>max_angles(i)
                solution_valid = false;
                return
            end
        end
    end
end
