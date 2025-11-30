code matlab
function firefly_algorithm()
    % Tham số
    num_fireflies = 20;
    max_iter = 100;
    alpha = 0.5;
    beta0 = 1.0;
    gamma = 1.0;
    dim = 2;          % số chiều
    L = -10;          % giới hạn dưới
    R = 10;           % giới hạn trên

    % Khởi tạo quần thể
    fireflies = L + (R-L).*rand(num_fireflies, dim);
    brightness = objective_function(fireflies);

    % Tìm con tốt nhất ban đầu
    [best_val, idx] = min(brightness);
    best = fireflies(idx,:);

    % Vẽ ban đầu
    figure; hold on;
    scatter(fireflies(:,1), fireflies(:,2), 50, 'filled');
    plot(best(1), best(2), 'rp', 'MarkerSize', 12, 'MarkerFaceColor','r');
    title('Firefly Algorithm - Sphere Function');
    xlabel('x1'); ylabel('x2');
    grid on;

    % Lặp
    for iter = 1:max_iter
        for i = 1:num_fireflies
            for j = 1:num_fireflies
                if brightness(j) < brightness(i)
                    % khoảng cách
                    r = norm(fireflies(i,:) - fireflies(j,:));
                    % độ hấp dẫn
                    beta = beta0 * exp(-gamma * r^2);
                    % cập nhật vị trí
                    fireflies(i,:) = fireflies(i,:) ...
                        + beta * (fireflies(j,:) - fireflies(i,:)) ...
                        + alpha * (rand(1,dim)-0.5);
                    % giới hạn
                    fireflies(i,:) = max(min(fireflies(i,:), R), L);
                end
            end
            % cập nhật độ sáng
            brightness(i) = objective_function(fireflies(i,:));
        end

        % cập nhật con tốt nhất
        [val, idx] = min(brightness);
        if val < best_val
            best_val = val;
            best = fireflies(idx,:);
        end

        % Vẽ trạng thái mỗi vòng lặp
        scatter(fireflies(:,1), fireflies(:,2), 30, 'b','filled');
        plot(best(1), best(2), 'rp', 'MarkerSize', 12, 'MarkerFaceColor','r');
        drawnow;

        fprintf('Iter %d | Best = %.6f\n', iter, best_val);
    end

    fprintf('\nBest solution found: (%.6f, %.6f)\nValue = %.6f\n', ...
        best(1), best(2), best_val);
end

function f = objective_function(x)
    % Sphere function: sum(x^2)
    f = sum(x.^2, 2);
end
