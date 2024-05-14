#include <bitset>
#include <iostream>
#include <cmath>

typedef union {
    float input;   // assumes sizeof(float) == sizeof(int)
    int output;
} FloatIntUnion;

std::bitset<32> floatToBitset(float f) {
    FloatIntUnion fiu;
    fiu.input = f;
    std::bitset<32> bits(fiu.output);
    return bits;
}

float bitsetToFloat(std::bitset<32> bits) {
    FloatIntUnion fiu;
    fiu.output = (int)(bits.to_ulong());
    return fiu.input;
}

int main() {
    float a, b;
    std::cout << "Ingrese dos numeros: ";
    std::cin >> a >> b;

    // Convertir a bitset
    std::bitset<32> a_bits = floatToBitset(a);
    std::bitset<32> b_bits = floatToBitset(b);

    // Extraer signo, exponente y significando
    std::bitset<1> a_sign(a_bits.to_string().substr(0, 1));
    std::bitset<8> a_exp(a_bits.to_string().substr(1, 8));
    std::bitset<23> a_sig(a_bits.to_string().substr(9, 23));

    std::bitset<1> b_sign(b_bits.to_string().substr(0, 1));
    std::bitset<8> b_exp(b_bits.to_string().substr(1, 8));
    std::bitset<23> b_sig(b_bits.to_string().substr(9, 23));

    // Realizar operaciones
    // Suma de exponentes
    int exp_sum = a_exp.to_ulong() + b_exp.to_ulong() - 127; // Restamos el bias
    // Multiplicación de los significandos
    float sig_mult = (1.0f + a_sig.to_ulong() / pow(2, 23)) * (1.0f + b_sig.to_ulong() / pow(2, 23));
    // Normalización y redondeo
    if (sig_mult >= 2.0f) {
        sig_mult /= 2;
        exp_sum++;
    }
    // Ensamblaje del resultado final
    std::bitset<32> result_bits((a_sign.to_ulong() ^ b_sign.to_ulong()) << 31 | exp_sum << 23 | static_cast<int>((sig_mult - 1.0f) * pow(2, 23)));

    // Verificar discrepancias con la operación de multiplicación de C++
    float mult = a * b;
    std::bitset<32> mult_bits = floatToBitset(mult);

    // Imprimir los patrones de bits
    std::cout << "a: " << a_bits << std::endl;
    std::cout << "b: " << b_bits << std::endl;
    std::cout << "a * b: " << mult_bits << std::endl;
    std::cout << "Resultado de la emulación: " << result_bits << std::endl;

    return 0;
}