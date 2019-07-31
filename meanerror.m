function erms = meanerror(x, Tref, mc)
G1 = x(1);
G2 = x(2);
O1 = x(3);
O2 = x(4);
N = length(Tref);
erms = sqrt(1/N*sum((Tref - (mc*G1 + O1)./(mc*G2 + O2)).^2));