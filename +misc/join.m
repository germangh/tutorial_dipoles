function y = join(expr, list)


y = list{1};
for i = 2:numel(list)
   y = [y expr list{i}];  %#ok<AGROW>
end



end