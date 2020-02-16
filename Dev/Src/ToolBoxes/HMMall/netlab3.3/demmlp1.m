%DEMMLP1 Demonstrate simple regression using a multi-layer perceptron
%
%	Description
%	The problem consists of one input variable X and one target variable
%	T with data generated by sampling X at equal intervals and then
%	generating target data by computing SIN(2*PI*X) and adding Gaussian
%	noise. A 2-layer network with linear outputs is trained by minimizing
%	a  sum-of-squares error function using the scaled conjugate gradient
%	optimizer.
%
%	See also
%	MLP, MLPERR, MLPGRAD, SCG
%

%	Copyright (c) Ian T Nabney (1996-2001)


% Generate the matrix of inputs x and targets t.

ndata = 20;			% Number of data points.
noise = 0.2;			% Standard deviation of noise distribution.
x = [0:1/(ndata - 1):1]';
randn('state', 1);
t = sin(2*pi*x) + noise*randn(ndata, 1);

clc
disp('This demonstration illustrates the use of a Multi-Layer Perceptron')
disp('network for regression problems.  The data is generated from a noisy')
disp('sine function.')
disp(' ')
disp('Press any key to continue.')
pause

% Set up network parameters.
nin = 1;			% Number of inputs.
nhidden = 3;			% Number of hidden units.
nout = 1;			% Number of outputs.
alpha = 0.01;			% Coefficient of weight-decay prior. 

% Create and initialize network weight vector.

net = mlp(nin, nhidden, nout, 'linear', alpha);

% Set up vector of options for the optimiser.

options = zeros(1,18);
options(1) = 1;			% This provides display of error values.
options(14) = 100;		% Number of training cycles. 

clc
disp(['The network has ', num2str(nhidden), ' hidden units and a weight decay'])
disp(['coefficient of ', num2str(alpha), '.'])
disp(' ')
disp('After initializing the network, we train it use the scaled conjugate')
disp('gradients algorithm for 100 cycles.')
disp(' ')
disp('Press any key to continue')
pause

% Train using scaled conjugate gradients.
[net, options] = netopt(net, options, x, t, 'scg');

disp(' ')
disp('Now we plot the data, underlying function, and network outputs')
disp('on a single graph to compare the results.')
disp(' ')
disp('Press any key to continue.')
pause

% Plot the data, the original function, and the trained network function.
plotvals = [0:0.01:1]';
y = mlpfwd(net, plotvals);
fh1 = figure;
plot(x, t, 'ob')
hold on
xlabel('Input')
ylabel('Target')
axis([0 1 -1.5 1.5])
[fx, fy] = fplot('sin(2*pi*x)', [0 1]);
plot(fx, fy, '-r', 'LineWidth', 2)
plot(plotvals, y, '-k', 'LineWidth', 2)
legend('data', 'function', 'network');

disp(' ')
disp('Press any key to end.')
pause
close(fh1);
clear all;
