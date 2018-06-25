function sortArray = zigzag(block)
% Funcao que vai implementar o algoritmo zigzag para um bloco de tamanho 8X8
% Funcao recebe um bloco com os componentes DCT 8x8

sortArray = zeros(64, 1);

%% Implementacao do zigzag manualmente

sortArray(1) = block(1, 1);
sortArray(2) = block(1, 2);
sortArray(3) = block(2, 1);
sortArray(4) = block(3, 1);
sortArray(5) = block(2, 2);
sortArray(6) = block(1, 3);
sortArray(7) = block(1, 4);
sortArray(8) = block(2, 3);
sortArray(9) = block(3, 2);
sortArray(10) = block(4, 1);
sortArray(11) = block(5, 1);
sortArray(12) = block(4, 2);
sortArray(13) = block(3, 3);
sortArray(14) = block(2, 4);
sortArray(15) = block(1, 5);
sortArray(16) = block(1, 6);
sortArray(17) = block(2, 5);
sortArray(18) = block(3, 4);
sortArray(19) = block(4, 3);
sortArray(20) = block(5, 2);
sortArray(21) = block(6, 1);
sortArray(22) = block(7, 1);
sortArray(23) = block(6, 2);
sortArray(24) = block(5, 3);
sortArray(25) = block(4, 4);
sortArray(26) = block(3, 5);
sortArray(27) = block(2, 6);
sortArray(28) = block(1, 7);
sortArray(29) = block(1, 8);
sortArray(30) = block(2, 7);
sortArray(31) = block(3, 6);
sortArray(32) = block(4, 5);
sortArray(33) = block(5, 4);
sortArray(34) = block(6, 3);
sortArray(35) = block(7, 2);
sortArray(36) = block(8, 1);
sortArray(37) = block(8, 2);
sortArray(38) = block(7, 3);
sortArray(39) = block(6, 4);
sortArray(40) = block(5, 5);
sortArray(41) = block(4, 6);
sortArray(42) = block(3, 7);
sortArray(43) = block(2, 8);
sortArray(44) = block(3, 8);
sortArray(45) = block(4, 7);
sortArray(46) = block(5, 6);
sortArray(47) = block(6, 5);
sortArray(48) = block(7, 4);
sortArray(49) = block(8, 3);
sortArray(50) = block(8, 4);
sortArray(51) = block(7, 5);
sortArray(52) = block(6, 6);
sortArray(53) = block(5, 7);
sortArray(54) = block(4, 8);
sortArray(55) = block(5, 8);
sortArray(56) = block(6, 7);
sortArray(57) = block(7, 6);
sortArray(58) = block(8, 5);
sortArray(59) = block(8, 6);
sortArray(60) = block(7, 7);
sortArray(61) = block(6, 8);
sortArray(62) = block(7, 8);
sortArray(63) = block(8, 7);
sortArray(64) = block(8, 8);

end