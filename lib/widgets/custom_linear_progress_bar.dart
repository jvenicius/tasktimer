import 'package:flutter/material.dart';

class CustomLinearProgressBar extends StatelessWidget {
  final double value; // Valor atual da barra de progresso // Cor da barra de progresso

  const CustomLinearProgressBar({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Borda arredondada
      child: LinearProgressIndicator(
        value: value,
        minHeight: 20, // Altura da barra de progresso
        backgroundColor: Colors.grey[300], // Cor de fundo da barra de progresso
        valueColor:
            const AlwaysStoppedAnimation<Color>(Colors.blue), // Cor da barra de progresso
      ),
    );
  }
}

// Exemplo de uso:
// CustomLinearProgressBar(value: 0.5, color: Colors.blue);
