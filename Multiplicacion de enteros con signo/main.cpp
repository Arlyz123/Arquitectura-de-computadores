#include <iostream>
#include <bitset>

// convertir un entero en una cadena binaria de 32 bits
std::string EnteroABinario(int n) {
    return std::bitset<32>(n).to_string();
}

// obtener la suma binaria de dos enteros
std::string SumaBinaria(int a, int b) {
    int suma = a + b;
    return std::bitset<32>(suma).to_string();
}

// multiplicación de dos enteros utilizando operaciones binarias
int MultiplicacionBinaria(int multiplicando, int multiplicador) {
    int resultado = 0;
    int absMultiplicando = abs(multiplicando);
    int absMultiplicador = abs(multiplicador);
    int producto = 0;

    // multiplicación bit a bit
    for (int i = 0; i < 32; i++) {
        int bitMenosSignificativo = absMultiplicador & 1;
        if (bitMenosSignificativo == 1) {
            producto += absMultiplicando;
        }
        absMultiplicando <<= 1;
        absMultiplicador >>= 1;
    }

    // determina el signo del resultado
    if ((multiplicando < 0) ^ (multiplicador < 0)) {
        resultado = -producto;
    }
    else {
        resultado = producto;
    }
    return resultado;
}

int main() {
    while (true) {
        system("cls");
        std::cout << "Algoritmo de multiplicacion de enteros con signo";

        
        std::cout << "\n\nIngrese el multiplicando: ";
        int multiplicando, multiplicador;
        std::cin >> multiplicando;

        std::cout << "Ingrese el multiplicador: ";
        std::cin >> multiplicador;

        int producto = MultiplicacionBinaria(multiplicando, multiplicador);
        std::cout << "\nMultiplicación normal: " << producto << std::endl;
        std::cout << "Multiplicación en binario: " << EnteroABinario(producto) << std::endl;

        // suma binaria de los multiplicandos
        std::cout << "Suma binaria de los multiplicandos: " << SumaBinaria(multiplicando, multiplicador) << std::endl;

        system("pause");
    }
}
