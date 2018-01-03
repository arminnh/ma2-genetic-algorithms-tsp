% CROSS_ORDER.M (ORDER CROSSOVER)
%
% Order crossover for TSP.
%
% Input parameters:
%    ParentOne, ParentTwo - The TSP individuals to apply crossover on in a
%                           certain representation.
%    Representation       - The representation the given parents are in.
%                           If omitted, 2 (path) is assumed.
%
% Output parameter:
%    ChildOne, ChildTwo   - Chromosomes created by mating, ready to be       
%                           mutated and/or evaluated, in the same format 
%                           as OldChrom.

function [ChildOne, ChildTwo] = cross_order(ParentOne, ParentTwo, Representation)

if nargin < 3, Representation = 2; end
if Representation == 1 
	ParentOne = adj2path(ParentOne);
	ParentTwo = adj2path(ParentTwo);
end

[~, cols] = size(ParentOne);
ChildOne = zeros(1, cols);
ChildTwo = zeros(1, cols);

rnd = sort(randi(cols, [1, 2]));
a = rnd(1);
b = rnd(2);

ChildOne(a:b) = ParentOne(a:b);
ChildTwo(a:b) = ParentTwo(a:b);

childOneIdx = rem(b, cols) + 1;
childTwoIdx = rem(b, cols) + 1;
for i = 1:cols
    current = rem(b + i-1, cols) + 1;
    
    if (all(ChildTwo ~= ParentOne(current)))
        ChildTwo(childTwoIdx) = ParentOne(current);
        childTwoIdx = rem(childTwoIdx, cols) + 1;
    end
    
    if (all(ChildOne ~= ParentTwo(current)))
        ChildOne(childOneIdx) = ParentTwo(current);
        childOneIdx = rem(childOneIdx, cols) + 1;
    end
end

if Representation == 1 
	ChildOne = path2adj(ChildOne);
	ChildTwo = path2adj(ChildTwo);
end

end

