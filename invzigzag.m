function outputBlock  = invzigzag(inputVector)
% Funcao que vai implementar o algoritmo zigzag inverso para um array de
% dimensao 64
% Funcao recebe um vetor dimensao 64, que corresponde ao vetor reordenado

outputBlock = zeros(8, 8);

outputBlock(1, 1) = inputVector(1);
outputBlock(1, 2) = inputVector(2);
outputBlock(2, 1) = inputVector(3);
outputBlock(3, 1) = inputVector(4);
outputBlock(2, 2) = inputVector(5);
outputBlock(1, 3) = inputVector(6);
outputBlock(1, 4) = inputVector(7);
outputBlock(2, 3) = inputVector(8);
outputBlock(3, 2) = inputVector(9);
outputBlock(4, 1) = inputVector(10);
outputBlock(5, 1) = inputVector(11);
outputBlock(4, 2) = inputVector(12);
outputBlock(3, 3) = inputVector(13);
outputBlock(2, 4) = inputVector(14);
outputBlock(1, 5) = inputVector(15);
outputBlock(1, 6) = inputVector(16);
outputBlock(2, 5) = inputVector(17);
outputBlock(3, 4) = inputVector(18);
outputBlock(4, 3) = inputVector(19);
outputBlock(5, 2) = inputVector(20);
outputBlock(6, 1) = inputVector(21);
outputBlock(7, 1) = inputVector(22);
outputBlock(6, 2) = inputVector(23);
outputBlock(5, 3) = inputVector(24);
outputBlock(4, 4) = inputVector(25);
outputBlock(3, 5) = inputVector(26);
outputBlock(2, 6) = inputVector(27);
outputBlock(1, 7) = inputVector(28);
outputBlock(1, 8) = inputVector(29);
outputBlock(2, 7) = inputVector(30);
outputBlock(3, 6) = inputVector(31);
outputBlock(4, 5) = inputVector(32);
outputBlock(5, 4) = inputVector(33);
outputBlock(6, 3) = inputVector(34);
outputBlock(7, 2) = inputVector(35);
outputBlock(8, 1) = inputVector(36);
outputBlock(8, 2) = inputVector(37);
outputBlock(7, 3) = inputVector(38);
outputBlock(6, 4) = inputVector(39);
outputBlock(5, 5) = inputVector(40);
outputBlock(4, 6) = inputVector(41);
outputBlock(3, 7) = inputVector(42);
outputBlock(2, 8) = inputVector(43);
outputBlock(3, 8) = inputVector(44);
outputBlock(4, 7) = inputVector(45);
outputBlock(5, 6) = inputVector(46);
outputBlock(6, 5) = inputVector(47);
outputBlock(7, 4) = inputVector(48);
outputBlock(8, 3) = inputVector(49);
outputBlock(8, 4) = inputVector(50);
outputBlock(7, 5) = inputVector(51);
outputBlock(6, 6) = inputVector(52);
outputBlock(5, 7) = inputVector(53);
outputBlock(4, 8) = inputVector(54);
outputBlock(5, 8) = inputVector(55);
outputBlock(6, 7) = inputVector(56);
outputBlock(7, 6) = inputVector(57);
outputBlock(8, 5) = inputVector(58);
outputBlock(8, 6) = inputVector(59);
outputBlock(7, 7) = inputVector(60);
outputBlock(6, 8) = inputVector(61);
outputBlock(7, 8) = inputVector(62);
outputBlock(8, 7) = inputVector(63);
outputBlock(8, 8) = inputVector(64);

end

