-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 25/04/2024 às 13:58
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `formaest`
--

CREATE DATABASE formaest2;

USE formaest2;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tipoutilizador`
--

CREATE TABLE `tipoutilizador` (
  `id_Tipo` int(11) NOT NULL,
  `descricao` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `tipoutilizador`
--

INSERT INTO `tipoutilizador` (`id_Tipo`, `descricao`) VALUES
(1, 'administrador'),
(2, 'docente'),
(3, 'aluno'),
(4, 'utilizador nao validado'),
(5, 'utilizador apagado');



-- --------------------------------------------------------
--
-- Estrutura para tabela `utilizador`
--

CREATE TABLE `utilizador` (
  `idUtilizador` int(11) NOT NULL,
  `nomeUtilizador` varchar(40) NOT NULL,
  `mail` varchar(40) NOT NULL,
  `imagem` varchar(30) NOT NULL DEFAULT 'default.png',
  `morada` varchar(60) NOT NULL,
  `pass` varchar(100) NOT NULL,
  `telemovel` varchar(9) NOT NULL,
  `tipoUtilizador` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `utilizador`
--

INSERT INTO `utilizador` (`idUtilizador`, `nomeUtilizador`, `mail`, `imagem`, `morada`, `pass`, `telemovel`, `tipoUtilizador`) VALUES
(1, 'admin', 'admin@formaest.pt', 'admin.png', 'Rua do Admin 1', '21232f297a57a5a743894a0e4a801fc3', '933888694', 1),
(2, 'docente', 'docente@formaest.pt', 'docente.png', 'Rua do Docente 1', 'ac99fecf6fcb8c25d18788d14a5384ee', '933888593', 2),
(3, 'aluno', 'aluno@gmail.com', 'aluno.png', 'Rua do Aluno 1', 'ca0cd09a12abade3bf0777574d9f987f', '933888492', 3);


--
-- Estrutura para tabela `estadocurso`
--

CREATE TABLE `estadocurso` (
  `id_estado_curso` int(11) NOT NULL,
  `desc` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `estadocurso`
--

INSERT INTO `estadocurso` (`id_estado_curso`, `desc`) VALUES
(1, 'Ativo'),
(2, 'Inativo'),
(3, 'Em Planeamento');

-- --------------------------------------------------------

--
-- Estrutura para tabela `tipo_curso`
--

CREATE TABLE `tipo_curso` (
  `id_tipo_curso` int(11) NOT NULL,
  `descricao` varchar(25) NOT NULL,
  `duracao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Despejando dados para a tabela `tipo_curso`
--

INSERT INTO `tipo_curso` (`id_tipo_curso`, `descricao`, `duracao`) VALUES
(1, 'CTSP', 2),
(2, 'Licenciatura', 3),
(3, 'Mestrado', 2);


-- --------------------------------------------------------

--
-- Estrutura para tabela `cursos`
--

CREATE TABLE `cursos` (
  `id_curso` int(11) NOT NULL,
  `titulo` varchar(100) NOT NULL,
  `descricao` text NOT NULL,
  `data_inicio` date NOT NULL,
  `data_fim` date NOT NULL,
  `limite_alunos` int(11) NOT NULL,
  `id_docente` int(11) DEFAULT NULL,
  `tipo_curso` int(11) NOT NULL,
  `estado_curso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `cursos`
--

INSERT INTO `cursos` (`id_curso`, `titulo`, `descricao`, `data_inicio`, `data_fim`, `limite_alunos`, `id_docente`, `tipo_curso`, `estado_curso`) VALUES
(1, 'Engenharia Informática', 'O melhor curso da FormaEst', '2024-04-01', '2025-04-01', 5, 2, 2, 1),
(2, 'Informatica e Multimédia', 'Informatica e Multimédia', '2024-04-23', '2024-12-24', 4, 2, 2, 1);


-- --------------------------------------------------------

--
-- Estrutura para tabela `status_inscricao`
--

CREATE TABLE `status_inscricao` (
  `id_status_inscricao` int(11) NOT NULL,
  `desc` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `status_inscricao`
--

INSERT INTO `status_inscricao` (`id_status_inscricao`, `desc`) VALUES
(1, 'Em Analise'),
(2, 'Aprovada'),
(3, 'Reprovada'),
(4, 'Apagada');

-- --------------------------------------------------------



--
-- Estrutura para tabela `inscricoes`
--

CREATE TABLE `inscricoes` (
  `id_inscricao` int(11) NOT NULL,
  `id_aluno` int(11) NOT NULL,
  `id_curso` int(11) NOT NULL,
  `data_inscricao` datetime NOT NULL,
  `v_exam_nacional` int(20) NOT NULL,
  `status_inscricao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `cursos`
--
ALTER TABLE `cursos`
  ADD PRIMARY KEY (`id_curso`),
  ADD KEY `id_docente` (`id_docente`),
  ADD KEY `tipo_curso` (`tipo_curso`),
  ADD KEY `fk_estado_curso` (`estado_curso`);

--
-- Índices de tabela `estadocurso`
--
ALTER TABLE `estadocurso`
  ADD PRIMARY KEY (`id_estado_curso`);

--
-- Índices de tabela `inscricoes`
--
ALTER TABLE `inscricoes`
  ADD PRIMARY KEY (`id_inscricao`),
  ADD KEY `id_aluno` (`id_aluno`),
  ADD KEY `id_curso` (`id_curso`),
  ADD KEY `status_inscricao` (`status_inscricao`);

--
-- Índices de tabela `status_inscricao`
--
ALTER TABLE `status_inscricao`
  ADD PRIMARY KEY (`id_status_inscricao`);

--
-- Índices de tabela `tipoutilizador`
--
ALTER TABLE `tipoutilizador`
  ADD PRIMARY KEY (`id_Tipo`);

--
-- Índices de tabela `tipo_curso`
--
ALTER TABLE `tipo_curso`
  ADD PRIMARY KEY (`id_tipo_curso`);

--
-- Índices de tabela `utilizador`
--
ALTER TABLE `utilizador`
  ADD PRIMARY KEY (`idUtilizador`),
  ADD UNIQUE KEY `nomeUtilizador` (`nomeUtilizador`),
  ADD KEY `tipoUtilizador` (`tipoUtilizador`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `cursos`
--
ALTER TABLE `cursos`
  MODIFY `id_curso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `inscricoes`
--
ALTER TABLE `inscricoes`
  MODIFY `id_inscricao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `status_inscricao`
--
ALTER TABLE `status_inscricao`
  MODIFY `id_status_inscricao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `tipoutilizador`
--
ALTER TABLE `tipoutilizador`
  MODIFY `id_Tipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `tipo_curso`
--
ALTER TABLE `tipo_curso`
  MODIFY `id_tipo_curso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `utilizador`
--
ALTER TABLE `utilizador`
  MODIFY `idUtilizador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `cursos`
--
ALTER TABLE `cursos`
  ADD CONSTRAINT `fk_docente` FOREIGN KEY (`id_docente`) REFERENCES `utilizador` (`idUtilizador`),
  ADD CONSTRAINT `fk_estado_curso` FOREIGN KEY (`estado_curso`) REFERENCES `estadocurso` (`id_estado_curso`),
  ADD CONSTRAINT `fk_tipo_curso` FOREIGN KEY (`tipo_curso`) REFERENCES `tipo_curso` (`id_tipo_curso`);

--
-- Restrições para tabelas `inscricoes`
--
ALTER TABLE `inscricoes`
  ADD CONSTRAINT `fk_aluno` FOREIGN KEY (`id_aluno`) REFERENCES `utilizador` (`idUtilizador`),
  ADD CONSTRAINT `fk_curso` FOREIGN KEY (`id_curso`) REFERENCES `cursos` (`id_curso`),
  ADD CONSTRAINT `fk_status_inscricao` FOREIGN KEY (`status_inscricao`) REFERENCES `status_inscricao` (`id_status_inscricao`);

--
-- Restrições para tabelas `utilizador`
--
ALTER TABLE `utilizador`
  ADD CONSTRAINT `fk_tipoUtilizador` FOREIGN KEY (`tipoUtilizador`) REFERENCES `tipoutilizador` (`id_Tipo`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
