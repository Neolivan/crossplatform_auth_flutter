# 🚀 crossplatform-auth-flutter  

## 📖 Introdução  

Este projeto foi desenvolvido como parte de um teste técnico.  

Ele consiste em um sistema de **gerenciamento de login**, além de uma **demonstração com dados mock** que simula o funcionamento de um aplicativo voltado para tornar as cidades mais limpas e otimizar o trabalho dos catadores de recicláveis.  

A proposta é oferecer uma plataforma em que moradores possam informar a presença de lixo reciclável em sua região, permitindo que os catadores localizem esses pontos com facilidade e tracem rotas até os locais mais próximos, tornando o processo mais ágil e eficiente.  

---

## 🌐 APIs externas  

- **Reqres.in**  
  Utilizada para chamadas referentes aos dados de usuário, oferecendo APIs REST com dados fictícios úteis para este tipo de aplicação.  
  🔗 [Documentação](https://reqres.in)  

- **OSRM (Open Source Routing Machine)**  
  Utilizada para gerar rotas a partir de pontos de latitude e longitude.  
  🔗 [Documentação](https://project-osrm.org/)  

---

## 📦 Bibliotecas utilizadas e motivos  

- **provider** → Gerenciamento de estado global. Foi escolhida pela familiaridade e experiência prévia, permitindo maior agilidade no desenvolvimento. O **Riverpod** foi considerado, mas optou-se pelo **Provider** devido ao tempo limitado.  
- **http** → Comunicação com o backend REST, realizando requisições HTTP (GET, POST, etc.).  
- **toastification** → Exibição de notificações *toast*, fornecendo feedback visual rápido e não intrusivo.  
- **shared_preferences** → Persistência local de dados simples, como tokens de autenticação e preferências.  
- **flutter_map** → Exibição de mapas no app. Escolhida por ser flexível e de código aberto, alternativa ao Google Maps.  
- **latlong2** → Utilitários para trabalhar com coordenadas geográficas (latitude e longitude).  
- **geolocator** → Acesso à localização atual do dispositivo, permitindo que catadores encontrem pontos próximos.  
- **flutter_launcher_icons** → Geração de ícones personalizados para múltiplas plataformas (Android, iOS e Web).  

---

## 🗂 Estrutura da aplicação  



```
lib/
├── main.dart                          # Ponto de entrada da aplicação
├── routes/
│   └── route_provider.dart            # Gerenciador de rotas da aplicação
├── screens/
│   ├── login.dart                     # Tela de login e autenticação
│   ├── main_page.dart                 # Tela principal com mapa e funcionalidades
│   ├── user_profile.dart              # Tela de perfil do usuário
│   └── not_found.dart                 # Tela de erro 404
├── widgets/
│   ├── avatar_pin_widget.dart         # Widget de pin com avatar no mapa
│   ├── theme_toggle_button.dart       # Botão para alternar tema
│   ├── user_profile_button.dart       # Botão de perfil do usuário
│   ├── forgot_password_dialog.dart    # Diálogo de recuperação de senha
│   └── register_dialog.dart           # Diálogo de registro de usuário
└── utils/
    ├── constants/
    │   ├── enums/
    │   │   ├── labels_enum.dart       # Enum com todos os textos da aplicação
    │   │   └── trash_type_enum.dart   # Enum com tipos de lixo
    │   └── themes/
    │       ├── app_colors.dart        # Cores da aplicação
    │       ├── app_themes.dart        # Temas claro e escuro
    │       └── themes.dart            # Configurações de tema
    ├── global_states/
    │   ├── theme_provider.dart        # Provider para gerenciar tema
    │   └── user_provider.dart         # Provider para gerenciar usuário
    ├── mixins/
    │   ├── colors/
    │   │   └── colors_utills.dart     # Utilitários de cores
    │   ├── form_validators/
    │   │   └── form_validators.dart   # Validadores de formulário
    │   ├── map_locator_utils/
    │   │   └── map_locator_utils.dart # Utilitários de localização
    │   └── toast_show/
    │       └── toast_show.dart        # Mixin para notificações toast
    ├── models/
    │   ├── trash_model.dart           # Modelo de dados para pontos de coleta
    │   └── user_model.dart            # Modelo de dados do usuário
    └── services/
        ├── base_request.dart          # Cliente HTTP base
        ├── map_routes_service/
        │   └── map_routes_service.dart # Serviço de rotas no mapa
        └── user/
            └── user_services.dart     # Serviços de usuário (login, registro, etc.)
```

#### Organização dos arquivos:

- **`main.dart`**: Configuração inicial da aplicação com providers e roteamento
- **`routes/`**: Gerenciamento centralizado de rotas com suporte a parâmetros
- **`screens/`**: Telas principais da aplicação (login, mapa, perfil)
- **`widgets/`**: Componentes reutilizáveis da interface
- **`utils/`**: Utilitários organizados por categoria:
  - **`constants/`**: Constantes, enums e configurações de tema
  - **`global_states/`**: Providers para gerenciamento de estado global
  - **`mixins/`**: Funcionalidades reutilizáveis (validações, notificações, etc.)
  - **`models/`**: Modelos de dados da aplicação
  - **`services/`**: Serviços para comunicação com APIs e funcionalidades externas

### Padrões utilizados  
- **Provider Pattern** → Gerenciamento de estado global  
- **Mixin Pattern** → Funcionalidades reutilizáveis  
- **Repository Pattern** → Abstração de serviços  
- **Factory Pattern** → Criação de modelos de dados  
- **Singleton Pattern** → Providers globais  

---

## 📱 Telas  

- **Login**  
  - Login  
  - Registro  
  - Recuperação de senha  

- **Perfil do Usuário**  
  - Edição de informações  
  - Remoção de conta  
  - Logout  

- **Página Principal**  
  - Visualização de pontos de coleta  
  - Geração de rotas com base na localização atual  
  - Adição de novo ponto de coleta na localização atual  

- **Página Não Encontrada (404)**  
  - Apresentada quando a rota não existe (principalmente na Web)  

---

## ✨ Outras funcionalidades  

- Alternância entre tema claro e escuro  

---

## 🧪 Notas para testes  

- **Login**: Para autenticação bem-sucedida, use o e-mail `eve.holt@reqres.in` ou outro listado na [documentação do Reqres.in](https://reqres.in).  
- **Registro**: Para criar uma conta com sucesso, também é necessário usar um dos e-mails da documentação.  

---

## 🐞 Bugs conhecidos  

- O botão de alternância de tema só funciona a partir do **segundo clique**. Após isso, funciona normalmente.  