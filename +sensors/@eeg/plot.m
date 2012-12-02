function h = plot(obj)

h = scatter3(obj.Cartesian(:,1), obj.Cartesian(:,2), obj.Cartesian(:,3), 'r', 'filled');

axis equal;
set(gca, 'visible', 'off');
set(gcf, 'color', 'white');

end