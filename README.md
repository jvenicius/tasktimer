### README

# Task Timer by Venícius.Dev

Task Timer by Venícius.Dev é um aplicativo Flutter projetado para ajudá-lo a gerenciar suas tarefas de forma eficiente usando um temporizador. O aplicativo permite que você adicione tarefas, defina uma duração para cada uma e receba notificações quando as tarefas forem concluídas. Ele também garante que as tarefas continuem a ser executadas mesmo quando o aplicativo estiver em segundo plano, com o tempo restante exibido nas notificações.

## Recursos

- **Adicionar Tarefas**: Crie novas tarefas e defina uma duração personalizada para cada uma.
- **Temporizador de Tarefas**: O temporizador conta o tempo restante para cada tarefa.
- **Notificações**: Receba notificações quando uma tarefa for concluída.
- **Armazenamento Persistente**: As tarefas são salvas usando `SharedPreferences` para que persistam mesmo após o fechamento do aplicativo.
- **Execução em Segundo Plano**: As tarefas continuam a ser executadas em segundo plano, e o tempo restante é exibido nas notificações.
- **Pausar e Retomar Tarefas**: Pause e retome as tarefas conforme necessário.
- **Tema Personalizável**: O aplicativo possui um tema personalizável usando tons de preto, branco e azul.

## Instalação

1. Clone o repositório:
   ```sh
   git clone https://github.com/seuusuario/task-timer.git
   ```
2. Navegue até o diretório do projeto:
   ```sh
   cd task-timer
   ```
3. Instale as dependências:
   ```sh
   flutter pub get
   ```
4. Execute o aplicativo:
   ```sh
   flutter run
   ```

## Uso

1. Abra o aplicativo.
2. Toque no botão "+" para adicionar uma nova tarefa.
3. Insira o nome da tarefa e selecione a duração usando o seletor de tempo no estilo de relógio digital.
4. Toque em "Adicionar Tarefa" para adicionar a tarefa à lista.
5. O temporizador para a tarefa começará automaticamente. Você pode pausar ou retomar o temporizador conforme necessário.
6. Quando a tarefa for concluída, você receberá uma notificação.
7. O aplicativo continua a rastrear as tarefas mesmo quando está em segundo plano, e o tempo restante é mostrado nas notificações.

## Permissões

O aplicativo requer permissões de notificação para enviar alertas quando as tarefas forem concluídas. Certifique-se de conceder as permissões necessárias quando solicitado.

## Contribuindo

Contribuições são bem-vindas! Por favor, faça um fork do repositório e crie um pull request com suas alterações.

## Licença

Este projeto está licenciado sob a Licença MIT.

---

Sinta-se à vontade para modificar e expandir este README conforme suas necessidades específicas.