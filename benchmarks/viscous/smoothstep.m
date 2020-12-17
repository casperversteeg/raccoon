function y = smoothstep(x, N)

y = zeros(size(x));
for n = 0:N
    y = y + (-1)^n * nchoosek(N+n, n) * nchoosek(2*N+1, N-n) * x.^(N+n+1);
end
xneg = find(x <= 0);
xpos = find(x >= 1);

y(xneg) = zeros(1,length(xneg));
y(xpos) = ones(1,length(xpos));

end