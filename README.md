# 🏥 Sistema de Gerenciamento de Clínica (Agendamentos)

## 📘 Visão Geral

Este projeto tem como objetivo criar um sistema completo de gerenciamento para uma Clínica de Especialidades, com foco em agendamentos de consultas, controle de pacientes, e gestão de médicos e convênios.
O sistema garante a integridade dos agendamentos, evita conflitos de horários e mantém um histórico auditável das consultas realizadas.

## 🎯 Objetivo da Aplicação

A aplicação integra os principais fluxos de negócio da clínica, conectando pacientes, médicos e convênios dentro de uma estrutura relacional confiável.

| Módulo | Descrição |
| :--- | :--- |
| 🧍‍♀️ **Gestão de Pacientes** | Cadastro e gerenciamento de pacientes e seus convênios associados. |
| 👨‍⚕️ **Gestão de Médicos** | Cadastro de médicos, suas especialidades e convênios atendidos. |
| 📅 **Agendamentos** | Módulo central para marcar, confirmar, cancelar e realizar consultas. |
| 🕵️ **Auditoria** | Registro automático de todas as mudanças de status das consultas (TRIGGER). |

---

## ⚙️ Requisitos Funcionais (RF)

* **RF01:** Cadastrar, editar e consultar Pacientes.
* **RF02:** Cadastrar, editar e consultar Médicos.
* **RF03:** Cadastrar e consultar Especialidades.
* **RF04:** Cadastrar e consultar Convênios.
* **RF05:** Associar Médicos às suas Especialidades.
* **RF06:** Associar Médicos aos Convênios que atendem.
* **RF07:** Agendar uma nova Consulta para um Paciente com um Médico.
* **RF08:** Alterar o status de uma Consulta (confirmar, cancelar, etc.).
* **RF09:** Listar a agenda de consultas por Médico e por dia (VIEW).
* **RF10:** Impedir que um Médico tenha duas consultas no mesmo horário.
* **RF11:** Impedir que um Paciente tenha duas consultas no mesmo horário.

---

## 📋 Regras de Negócio (RN)

| Código | Regra |
| :--- | :--- |
| **RN01** | O CPF do Paciente deve ser único. |
| **RN02** | O CRM do Médico deve ser único. |
| **RN03** | Um Médico não pode ter duas consultas no mesmo horário (UNIQUE). |
| **RN04** | Um Paciente não pode ter duas consultas no mesmo horário (UNIQUE). |
| **RN05** | Uma Consulta só pode ser agendada se o Médico atender pela Especialidade selecionada (FK composta). |
| **RN06** | O status inicial de uma Consulta deve ser sempre `AGENDADA` (DEFAULT). |
| **RN07** | Status válidos: `AGENDADA`, `CONFIRMADA`, `CANCELADA`, `REALIZADA` (CHECK). |
| **RN08** | Toda mudança de status deve ser auditada (TRIGGER). |

---

## 📊 Requisitos Não-Funcionais (RNF)

| Código | Descrição |
| :--- | :--- |
| **RNF01** | Autenticação para acesso seguro. |
| **RNF02** | Consultas da VIEW otimizadas para retornar em < 3 segundos (ÍNDICES). |
| **RNF03** | Integridade total via FOREIGN KEYS. |
| **RNF04** | Rotina de backup diário. |
| **RNF05** | Auditoria de todas as alterações de status (TRIGGER + `auditoria_consulta`). |

---

## 🧩 Modelo de Dados (Diagrama ER)

### 📎 Diagrama Lógico Completo – 8 Tabelas Relacionadas


**Tabelas principais:**

* 🏥 `convenio`
* 💉 `especialidade`
* 👨‍⚕️ `medico`
* 🧍‍♂️ `paciente`
* 🔗 `medico_especialidade` (N:N)
* 🔗 `medico_convenio` (N:N)
* 📅 `consulta` (Transacional)
* 🕵️ `auditoria_consulta` (Log via Trigger)

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia | Descrição |
| :--- | :--- |
| 🐘 **PostgreSQL** | Banco de dados relacional principal. |
| 💬 **SQL (DDL, DML)** | Criação e manipulação de tabelas e dados. |
| ⚙️ **PL/pgSQL** | Funções e triggers para auditoria. |
| 🧠 **Views & Constraints** | Integridade e performance garantidas. |

---

## 🚀 Como Executar o Projeto

Execute os scripts na ordem abaixo no pgAdmin 4 ou `psql`:

```bash
-- 1️⃣ Criação do esquema e estrutura base
\i 01_schema_v2.sql

-- 2️⃣ Inserção de dados e testes de auditoria
\i 02_dados_v2.sql

-- 3️⃣ Criação da view de agenda médica
\i 03_view.sql