# 👨‍🍳 Chef de Voz

O **Chef de Voz** é um aplicativo Flutter que utiliza reconhecimento de voz e inteligência artificial para sugerir receitas criativas com os ingredientes que você tem em casa. Basta falar os ingredientes, e o Chef te responde com uma ou mais receitas práticas, com um toque divertido e amigável.

## 🚀 Funcionalidades

- 🎙️ Reconhecimento de voz com `speech_to_text`
- 🤖 Geração de receitas usando a API Gemini (Google AI)
- 📄 Exibição das receitas com suporte a Markdown
- 🧑‍🍳 Interface intuitiva e amigável
- 🔥 Botão de microfone animado

## 🛠️ Tecnologias Utilizadas

- [Flutter](https://flutter.dev/)
- [speech_to_text](https://pub.dev/packages/speech_to_text)
- [flutter_markdown](https://pub.dev/packages/flutter_markdown)
- [HTTP](https://pub.dev/packages/http)
- Google Gemini API (via HTTP request)

## 📦 Dependências

Adicione ao `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  speech_to_text: ^6.3.0
  flutter_markdown: ^0.6.14
  http: ^0.14.0
```

> ⚠️ Lembre-se de substituir a chave da API Gemini no código por sua própria chave obtida em:  
> [Google AI Studio](https://makersuite.google.com/app)

## 📲 Como rodar o app

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/chef-de-voz.git
   cd chef-de-voz
   ```

2. Instale as dependências:
   ```bash
   flutter pub get
   ```

3. Rode o app:
   ```bash
   flutter run
   ```

> Obs: Para utilizar o reconhecimento de voz, certifique-se de testar em um **dispositivo físico** (Android ou iOS) com permissão para uso do microfone.

## 📁 Estrutura do Projeto

```
lib/
├── main.dart             # Tela principal e lógica do app
assets/
└── images/
    └── chef_logo.png     # Logo do Chef de Voz
```

## 💡 Ideias Futuras

- 🎨 Tela splash e transições suaves
- 🧾 Histórico de receitas
- 🗣️ Resposta falada usando TTS
- 📱 Compartilhar receitas em redes sociais

---
