clc;  % Limpa a tela
clear all;  % Limpa as variáveis da workspace
close all;  % Fecha gráficos abertos

% Nomes dos ativos
ativos = {"PETR4", "BBDC4", "TIMS3", "CRFB3", "CPLE6", "ABEV3", "EMBR3", "MGLU3", "NTCO3", "RAIL3"};

% Matriz de retornos fornecida
X = [
    2.28, 4.22, -5.82, -24.54, -2.85, -1.91, 4.19, -0.31, 4.20, -4.25;
    -8.53, -5.90, 5.57, 3.12, -2.30, 1.71, 2.43, -20.23, 3.69, -8.47;
    8.25, 25.67, 1.44, -3.13, 3.37, 11.05, 6.89, 9.85, -9.24, -1.35;
    -1.70, 0.40, 10.14, 2.66, 8.49, 1.49, 21.19, -8.13, -3.93, 6.90;
    0.90, 0.90, 0.89, -9.07, 2.42, -1.30, -0.22, -2.74, 4.65, 5.12;
    -6.48, -9.31, -9.90, -11.19, -0.11, -4.86, 8.64, -8.90, -10.49, -1.79;
    15.49, -1.74, 1.87, -18.05, -5.05, -2.72, 0.12, -24.44, -7.06, -9.43;
    -15.42, 0.15, -5.61, 16.14, 0.89, -0.72, 36.35, -15.49, 9.44, -2.46;
    -0.77, -10.42, 4.79, -16.39, -2.22, -3.82, 7.24, 2.07, 1.94, -1.47;
    8.62, -10.18, -3.29, 9.79, 9.51, -4.73, 4.14, -2.78, -5.27, 0.48;
    3.70, 5.04, 4.00, 26.42, 12.75, 5.53, 22.23, 6.93, 2.43, 0.22;
    3.37, 16.30, 13.65, 0.79, -2.73, 6.45, 2.15, 51.88, 29.33, 2.64;
    0.29, -2.17, 1.88, -13.26, 3.46, -1.91, -11.65, -37.26, -12.43, -2.23;
    8.45, -4.35, 3.33, -25.22, 3.59, -5.27, -0.16, -23.19, -4.08, 2.10;
    2.67, -10.26, 0.49, 22.50, 0.84, -6.86, -2.52, -17.61, -16.91, -3.83;
    5.35, 1.28, -1.92, 19.14, 11.73, -3.57, -2.06, -0.59, 9.14, 4.68;
    20.46, 7.47, 5.59, -11.91, -7.48, 6.94, -6.59, -11.32, 20.52, 6.63;
    10.21, 12.14, 2.61, -18.24, -9.27, 7.02, 14.26, -7.80, -13.84, 4.96;
    12.95, 5.32, 14.23, -7.88, -1.56, -1.19, 1.47, 0.91, -16.21, 4.87;
    -7.09, 0.84, 2.61, -18.24, -9.27, 7.02, 14.26, -19.65, -0.85, -4.37;
    -3.18, -6.58, 3.99, 11.30, -1.77, -1.98, 5.61, -19.65, -0.85, -4.37;
    6.41, -3.61, -4.92, -7.00, -2.10, -5.92, 22.10, 61.68, 25.32, -1.24;
    -8.10, -2.64, -3.15, -17.93, 13.57, -3.99, 5.61, -19.65, -0.85, -4.37;
    2.22, -21.48, 1.52, 1.10, 0.00, -0.50, -1.45, -23.71, -21.67, -12.10
];

Q = cov(X, 1);  % Matriz de covariância dos retornos
[m, n] = size(X);  % Número de períodos de retorno e número de ativos
X0 = zeros(n, 1);  % Vetor inicial de zeros

% Resolvendo o problema de otimização quadrática para encontrar a carteira ótima
[Car_ot, Sc, lambda] = qp(X0, 2*Q, [], ones(1, n), 1, zeros(n, 1), []);

% Cálculos para o retorno e risco dos ativos
Rma = mean(X);  % Retorno médio dos ativos
Sa = sqrt(diag(Q));  % Risco (desvio-padrão) dos ativos
Rc = Rma * Car_ot;  % Retorno da carteira ótima

% Cálculo das porcentagens de cada ativo na carteira ótima
porcentagens = Car_ot * 100;  % Multiplica por 100 para obter porcentagens

% Exibindo as porcentagens de alocação de cada ativo
disp('Porcentagens de investimento em cada ativo na carteira ótima:');
for i = 1:n
    fprintf('%s: %.2f%%\n', ativos{i}, porcentagens(i));
end

% Cores para cada ativo
cores = lines(n);  % Utiliza uma paleta de cores pré-definida para distinguir os ativos

% Plotando os retornos e riscos dos ativos individuais
for i = 1:n
    plot(Sa(i), Rma(i), 'o', 'Color', cores(i, :), 'MarkerSize', 8);  % Plota cada ativo com uma cor diferente
    hold on;
    text(Sa(i), Rma(i), ativos{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Color', cores(i, :));  % Coloca o nome do ativo na mesma cor
end

% Plotando a carteira ótima em azul
plot(sqrt(Sc), Rc, 'b*', 'DisplayName', 'Carteira Ótima', 'MarkerSize', 8);

% Plotando a fronteira eficiente em verde
k = 0.9;
while k >= 0.1
    Ck = k * Rma(1) + (1 - k) * Rma(2);  % Retorno de uma carteira com pesos k e (1-k)
    Sk = sqrt(k^2 * Q(1, 1) + (1 - k)^2 * Q(2, 2) + 2 * k * (1 - k) * Q(1, 2));  % Risco da carteira
    plot(Sk, Ck, 'g+', 'DisplayName', 'Fronteira Eficiente');  % Plota a fronteira eficiente em verde
    k = k - 0.1;
end

% Legenda e título
legend([ativos, {'Carteira Ótima', 'Fronteira Eficiente'}], 'Location', 'bestoutside');
title('Modelo Média-Variância de Markowitz');
xlabel('Risco (Desvio-Padrão)');
ylabel('Retorno');
hold off;
