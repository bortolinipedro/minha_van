import 'package:flutter/services.dart';

class InputMasks {
  // Máscara para CEP (00000-000)
  static TextInputFormatter cepMask = FilteringTextInputFormatter.allow(RegExp(r'[0-9-]'));
  
  // Máscara para telefone ((00) 00000-0000)
  static TextInputFormatter phoneMask = FilteringTextInputFormatter.allow(RegExp(r'[0-9()\s-]'));
  
  // Máscara para CPF (000.000.000-00)
  static TextInputFormatter cpfMask = FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]'));
  
  // Máscara para números (apenas números)
  static TextInputFormatter numbersOnly = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  
  // Máscara para texto (letras, números e espaços)
  static TextInputFormatter textOnly = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ÿ\s]'));
  
  // Máscara para códigos de grupo (letras e números, sem espaços)
  static TextInputFormatter groupCodeMask = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'));
  
  // Máscara para estado (apenas 2 letras)
  static TextInputFormatter stateMask = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZÀ-ÿ]'));
}

class InputValidators {
  // Validar CEP (deve ter 8 dígitos)
  static String? validateCep(String? value) {
    if (value == null || value.isEmpty) {
      return 'CEP é obrigatório';
    }
    
    // Remove caracteres não numéricos
    final cleanCep = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cleanCep.length != 8) {
      return 'CEP deve ter 8 dígitos';
    }
    
    return null;
  }
  
  // Validar telefone (deve ter pelo menos 10 dígitos)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }
    
    // Remove caracteres não numéricos
    final cleanPhone = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cleanPhone.length < 10 || cleanPhone.length > 11) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }
    
    return null;
  }
  
  // Validar CPF (deve ter 11 dígitos)
  static String? validateCpf(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }
    
    // Remove caracteres não numéricos
    final cleanCpf = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cleanCpf.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }
    
    // Validação básica de CPF (verificar se não é sequência)
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cleanCpf)) {
      return 'CPF inválido';
    }
    
    return null;
  }
  
  // Validar nome (deve ter pelo menos 2 caracteres)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    
    if (value.trim().length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    
    if (value.trim().length > 100) {
      return 'Nome deve ter no máximo 100 caracteres';
    }
    
    return null;
  }
  
  // Validar email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatório';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'E-mail inválido';
    }
    
    return null;
  }
  
  // Validar rua (deve ter pelo menos 3 caracteres)
  static String? validateStreet(String? value) {
    if (value == null || value.isEmpty) {
      return 'Rua é obrigatória';
    }
    
    if (value.trim().length < 3) {
      return 'Rua deve ter pelo menos 3 caracteres';
    }
    
    if (value.trim().length > 100) {
      return 'Rua deve ter no máximo 100 caracteres';
    }
    
    return null;
  }
  
  // Validar número
  static String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Número é obrigatório';
    }
    
    if (value.trim().length > 10) {
      return 'Número deve ter no máximo 10 caracteres';
    }
    
    return null;
  }
  
  // Validar bairro (deve ter pelo menos 2 caracteres)
  static String? validateNeighborhood(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bairro é obrigatório';
    }
    
    if (value.trim().length < 2) {
      return 'Bairro deve ter pelo menos 2 caracteres';
    }
    
    if (value.trim().length > 50) {
      return 'Bairro deve ter no máximo 50 caracteres';
    }
    
    return null;
  }
  
  // Validar cidade (deve ter pelo menos 2 caracteres)
  static String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cidade é obrigatória';
    }
    
    if (value.trim().length < 2) {
      return 'Cidade deve ter pelo menos 2 caracteres';
    }
    
    if (value.trim().length > 50) {
      return 'Cidade deve ter no máximo 50 caracteres';
    }
    
    return null;
  }
  
  // Validar estado (deve ter exatamente 2 caracteres)
  static String? validateState(String? value) {
    if (value == null || value.isEmpty) {
      return 'Estado é obrigatório';
    }
    
    if (value.trim().length != 2) {
      return 'Estado deve ter 2 caracteres';
    }
    
    return null;
  }
}

class InputFormatters {
  // Formatar CEP enquanto digita
  static String formatCep(String value) {
    // Remove tudo que não é número
    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Aplica máscara 00000-000
    if (numbers.length <= 5) {
      return numbers;
    } else {
      return '${numbers.substring(0, 5)}-${numbers.substring(5, numbers.length > 8 ? 8 : numbers.length)}';
    }
  }
  
  // Formatar telefone enquanto digita
  static String formatPhone(String value) {
    // Remove tudo que não é número
    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Aplica máscara (00) 00000-0000
    if (numbers.length <= 2) {
      return numbers;
    } else if (numbers.length <= 6) {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2)}';
    } else if (numbers.length <= 10) {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 6)}-${numbers.substring(6)}';
    } else {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7, numbers.length > 11 ? 11 : numbers.length)}';
    }
  }
  
  // Formatar CPF enquanto digita
  static String formatCpf(String value) {
    // Remove tudo que não é número
    final numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Aplica máscara 000.000.000-00
    if (numbers.length <= 3) {
      return numbers;
    } else if (numbers.length <= 6) {
      return '${numbers.substring(0, 3)}.${numbers.substring(3)}';
    } else if (numbers.length <= 9) {
      return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6)}';
    } else {
      return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9, numbers.length > 11 ? 11 : numbers.length)}';
    }
  }
} 