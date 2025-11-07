# 🏥 Sistema de Gerenciamento de Clínica (Agendamentos)

Este projeto foi desenvolvido com o objetivo de criar um **sistema completo de gerenciamento para uma Clínica de Especialidades**, focado nos fluxos de **Agendamento de Consultas**, **Controle de Pacientes** e **Gestão de Médicos**.

O foco principal é garantir a **integridade dos agendamentos** (evitando conflitos de horários), rastrear o ciclo de vida das consultas (status) e fornecer uma **visão consolidada** da agenda médica e do histórico do paciente.

---

## 🎯 Objetivo da Aplicação

A aplicação integra os principais fluxos de negócio de uma clínica, gerenciando as interações entre pacientes, médicos e seus respectivos convênios e especialidades.

| Módulo | Descrição |
| :--- | :--- |
| **Gestão de Pacientes** | Cadastro e gerenciamento de pacientes e seus convênios associados. |
| **Gestão de Médicos** | Cadastro de médicos, suas especialidades e os convênios que atendem. |
| **Agendamentos** | Módulo central para marcar, confirmar, cancelar e realizar consultas. |
| **Auditoria** | Rastreamento automático de todas as mudanças de status das consultas via `TRIGGER`. |

---

## ⚙️ Requisitos Funcionais (RF)

* **RF01:** Cadastrar, editar e consultar Pacientes.
* **RF02:** Cadastrar, editar e consultar Médicos.
* **RF03:** Cadastrar e consultar Especialidades.
* **RF04:** Cadastrar e consultar Convênios.
* **RF05:** Associar Médicos às suas Especialidades.
* **RF06:** Associar Médicos aos Convênios que eles atendem.
* **RF07:** Agendar uma nova Consulta para um Paciente com um Médico.
* **RF08:** Alterar o status de uma Consulta (confirmar, cancelar, etc.).
* **RF09:** Listar a agenda de consultas por Médico e por dia (através da `VIEW`).
* **RF10:** Impedir que um Médico tenha duas consultas no mesmo horário.
* **RF11:** Impedir que um Paciente tenha duas consultas no mesmo horário.

---

## 📋 Regras de Negócio (RN)

* **RN01:** O CPF do Paciente deve ser único.
* **RN02:** O CRM do Médico deve ser único.
* **RN03:** Um Médico não pode ter duas consultas agendadas no mesmo horário (Garantido por `UNIQUE`).
* **RN04:** Um Paciente não pode ter duas consultas agendadas no mesmo horário (Garantido por `UNIQUE`).
* **RN05:** Uma Consulta só pode ser agendada se o Médico atender pela Especialidade selecionada (Garantido por `FOREIGN KEY` composta).
* **RN06:** O status inicial de uma nova Consulta deve ser sempre 'AGENDADA' (Garantido por `DEFAULT`).
* **RN07:** Os únicos status válidos para uma consulta são: 'AGENDADA', 'CONFIRMADA', 'CANCELADA', 'REALIZADA' (Garantido por `CHECK`).
* **RN08:** Toda mudança de status de uma consulta deve ser auditada (Garantido por `TRIGGER`).

---

## 📊 Requisitos Não-Funcionais (RNF)

* **RNF01 (Segurança):** O acesso ao sistema deve ser controlado por autenticação.
* **RNF02 (Desempenho):** A consulta da agenda do dia (VIEW) deve retornar resultados em menos de 3 segundos (Otimizado por `ÍNDICES`).
* **RNF03 (Confiabilidade):** O sistema não deve perder dados de agendamento (Garantido por `CONSTRAINTS` e `FOREIGN KEYS`).
* **RNF04 (Backup):** Deve existir uma rotina de backup diário do banco de dados.
* **RNF05 (Auditabilidade):** O sistema deve registrar quem e quando um status de consulta foi alterado (Implementado com `TRIGGER` e `auditoria_consulta`).

---

## DatabaseDiagram
Este é o diagrama lógico final do nosso banco de dados, mostrando as 8 tabelas e seus relacionamentos diretos.


**As 8 tabelas do sistema são:**
1.  `convenio`
2.  `especialidade`
3.  `medico`
4.  `paciente`
5.  `medico_especialidade` (Tabela Associativa N:N)
6.  `medico_convenio` (Tabela Associativa N:N)
7.  `consulta` (Tabela principal de transações)
8.  `auditoria_consulta` (Tabela de log/trigger)

---

## 🛠️ Tecnologias Utilizadas

* **Banco de Dados:** `PostgreSQL`
* **Linguagem:** `SQL` (DDL, DML)
* **Recursos Avançados:**
    * `Triggers` e `Functions` (plpgsql) para auditoria automática.
    * `Views` para simplificação de relatórios complexos.
    * `Constraints` (CHECK, UNIQUE, FKs Compostas) para garantir a integridade das Regras de Negócio.

---

## 🚀 Como Executar o Projeto

Para recriar o banco de dados do zero, execute os scripts SQL na ordem exata abaixo:

1.  **`01_schema_v2.sql`**
    * Cria todas as 8 tabelas, `CONSTRAINTS`, `ÍNDICES`, a `FUNCTION` e o `TRIGGER` de auditoria.

2.  **`02_dados_v2.sql`**
    * Popula o banco com 10 pacientes, 4 médicos, 11 consultas e todos os dados de apoio.
    * Executa `UPDATEs` no final para testar o `TRIGGER` de auditoria.

3.  **`03_view.sql`**
    * Cria a `VIEW vw_agenda_completa`.
    * Executa um `SELECT` de exemplo na view para listar a agenda do Dr. House.

---

## 👨‍💻 Autores

* [Naldo Junior]
* [Samuel Gomes Soares]
* [Gabriel Barbosa]
* [João Victor]
