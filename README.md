# HPC+ Mobile App

A aplicação mobile oficial do **Hinário Povo Cantai (HPC)** da Igreja Metodista Unida em Angola (IMUA), desenvolvida em Flutter.

## Arquitectura

O projeto segue a **Clean Architecture** com separação clara de responsabilidades:
- **Presentation Layer:** Telas, Widgets e state management usando `Riverpod`.
- **Domain Layer:** Regras de negócio, Entidades (`Freezed`) e Repositórios (interfaces).
- **Data Layer:** Implementações de repositórios, chamadas de API (`Dio`) e cache local (`Hive`/`SharedPreferences`).

## Tecnologias Principais

- **Flutter 3.x**
- **Gestão de Estado:** `flutter_riverpod`
- **Navegação:** `go_router` (StatefulShellRoute para bottom navigation)
- **Rede:** `dio`
- **Modelagem de Dados:** `freezed` & `json_serializable`
- **Tipografia:** `google_fonts`
- **Animações:** `lottie`

## Setup do Projecto

1. **Instalar as dependências:**
   ```bash
   flutter pub get
   ```

2. **Gerar arquivos (Freezed, JSON Serializable):**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Executar a aplicação:**
   ```bash
   flutter run
   ```

## Acessibilidade e Identidade Visual

A interface utiliza **Material Design 3**, suporta nativamente **Light / Dark Mode** baseada nas definições do sistema, e utiliza uma paleta de cores suaves inspiradas em valores cristãos, garantindo contrastes adequados (WCAG 2.1) e fontes legíveis.

## Testes

Executar todos os testes de unidade e de widget (cobertura mínima recomendada de 80%):
```bash
flutter test --coverage
```
