# Sistema de Gestão para Clínica de Especialidades Médicas

## 1. Visão Geral do Projeto
Este projeto consiste no desenvolvimento de um sistema completo para o gerenciamento de agendamentos em uma clínica médica. O foco principal desta etapa (Fase 2) foi a implementação da lógica de negócio diretamente no Banco de Dados (SGBD MySQL) para garantir integridade, segurança e auditoria, além do desenvolvimento de uma API Backend em Node.js para interface com o sistema.

O sistema foi projetado para resolver problemas de conflitos de agenda (duplicidade de horários), validação de cobertura de convênios e rastreabilidade de alterações (logs).

## 2. Tecnologias Utilizadas
* **Banco de Dados:** MySQL 8.0
* **Backend:** Node.js
* **Framework Web:** Express.js
* **Driver de Banco:** mysql2
* **Ferramenta de Testes:** Thunder Client / Postman

## 3. Modelagem de Dados e Estrutura do Banco
O banco de dados `clinica_especialidades` foi modelado seguindo a 3ª Forma Normal (3FN). A estrutura resolve relacionamentos do tipo N:N através de entidades associativas e contempla requisitos de segurança e auditoria que não estavam presentes na versão anterior.

O esquema é composto por **9 tabelas**:

### 3.1. Tabelas de Acesso e Domínio
* **`usuario`**: Armazena credenciais de acesso (login/senha) e define o perfil (ADMIN, MEDICO, PACIENTE).
* **`convenio`**: Catálogo de planos de saúde aceitos.
* **`especialidade`**: Catálogo de especialidades médicas.

### 3.2. Tabelas de Entidades Principais
* **`medico`**: Dados profissionais, vinculado à tabela de usuários.
* **`paciente`**: Dados pessoais e convênio titular, vinculado à tabela de usuários.
* **`consulta`**: Entidade central que registra o agendamento (Data, Hora, Valor, Status).

### 3.3. Tabelas Associativas (Resolução de N:N)
* **`medico_especialidade`**: Relaciona quais especialidades cada médico possui.
* **`medico_convenio`**: Relaciona quais convênios cada médico atende, permitindo a validação de regras de negócio.

### 3.4. Tabela de Log
* **`auditoria_consulta`**: Armazena o histórico de alterações de status das consultas (valor anterior, novo valor, data e responsável), garantindo a rastreabilidade exigida.

## 4. Lógica de Negócio Implementada (SQL)
A inteligência do sistema reside no banco de dados através de objetos programáveis:

### 4.1. Stored Procedures
* **`prc_agendar_consulta`**: Orquestra o processo de agendamento. Realiza a verificação de disponibilidade e, somente se o horário estiver livre, executa a inserção.

### 4.2. Triggers (Gatilhos)
* **`trg_validar_convenio_medico` (BEFORE INSERT)**: Impede o agendamento caso o médico não atenda o convênio do paciente. Dispara um erro de banco de dados e aborta a transação.
* **`trg_log_auditoria` (AFTER UPDATE)**: Monitora a tabela de consultas. Ao detectar mudança de status, insere automaticamente um registro na tabela `auditoria_consulta`.

### 4.3. Stored Functions
* **`fn_verificar_disponibilidade`**: Retorna booleano indicando se o médico possui agenda livre no horário solicitado.
* **`fn_faturamento_medico`**: Calcula e retorna o valor total monetário das consultas realizadas por um médico.

## 5. Documentação da API (Backend)
O Backend atua como interface RESTful, delegando as validações para o banco de dados.

| Método | Rota | Descrição |
| :--- | :--- | :--- |
| **GET** | `/pacientes` | Lista todos os pacientes cadastrados. |
| **GET** | `/medicos` | Lista todos os médicos cadastrados. |
| **POST** | `/agendar` | Executa a procedure `prc_agendar_consulta`. Retorna erro 400 se houver conflito de horário ou convênio. |
| **GET** | `/medicos/:id/faturamento` | Executa a função de cálculo financeiro. |
| **PATCH** | `/consultas/:id/cancelar` | Atualiza o status para 'CANCELADA', acionando a trigger de auditoria. |
| **CRUD** | `/pacientes`, `/medicos` | Endpoints completos (GET, POST, PUT, DELETE) para gestão cadastral. |

## 6. Instruções de Instalação e Execução

### Pré-requisitos
* MySQL Server instalado e rodando.
* Node.js e NPM instalados.

### Passo 1: Configuração do Banco de Dados
1.  Acesse a pasta `banco_de_dados`.
2.  Execute os scripts SQL na seguinte ordem obrigatória (para evitar erros de chave estrangeira):
    * `00_criar_banco.sql`
    * `01_estrutura.sql`
    * `02_logica.sql` (Contém as Procedures, Triggers e Functions).
    * `03_dados.sql`
    * `04_view.sql`

### Passo 2: Configuração do Backend
1.  Na raiz do projeto, abra o arquivo `db.js` e configure a senha do seu MySQL:
    ```javascript
    password: 'sua_senha_aqui'
    ```
2.  Instale as dependências do projeto:
    ```bash
    npm install
    ```
3.  Inicie o servidor:
    ```bash
    node index.js
    ```
4.  O servidor estará rodando em `http://localhost:3000`.

## 7. Autores
Projeto desenvolvido para a disciplina CONECTAR BANCO DE DADOS COM P-O-O pelos alunos:

* **Naldo Junior**
* **Samuel Gomes**
* **João Victor**
* **Gabriel Barbosa**


