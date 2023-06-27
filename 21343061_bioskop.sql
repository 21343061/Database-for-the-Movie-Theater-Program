-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 04, 2023 at 10:34 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `21343061_bioskop`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_movies` (IN `id_movies` INT)  BEGIN
SELECT * FROM Tb061_film
WHERE id_film = id_movies;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `detail_film_v`
-- (See below for the actual view)
--
CREATE TABLE `detail_film_v` (
`judul` varchar(35)
,`genre` varchar(35)
,`durasi` varchar(10)
,`waktu_mulai` datetime
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `detail_tiket_v`
-- (See below for the actual view)
--
CREATE TABLE `detail_tiket_v` (
`judul` varchar(35)
,`waktu_mulai` datetime
,`harga` varchar(20)
,`total_pembayaran` varchar(20)
,`metode_pembayaran` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `jadwal_v`
-- (See below for the actual view)
--
CREATE TABLE `jadwal_v` (
`judul` varchar(35)
,`waktu_mulai` datetime
,`nama_studio` varchar(35)
);

-- --------------------------------------------------------

--
-- Table structure for table `tb061_film`
--

CREATE TABLE `tb061_film` (
  `Id_Film` varchar(5) NOT NULL,
  `Judul` varchar(35) DEFAULT NULL,
  `Genre` varchar(35) DEFAULT NULL,
  `Durasi` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb061_film`
--

INSERT INTO `tb061_film` (`Id_Film`, `Judul`, `Genre`, `Durasi`) VALUES
('43', 'Hello Ghost', 'Comedy', '1 Jam 30 M'),
('44', 'Buya Hamka', 'Drama Biografi', '1 Jam 45 M'),
('45', 'Fast X', 'Action', '2 Jam 21 M'),
('46', 'Little Mermaid', 'Fantasy', '2 Jam 15 M'),
('47', 'Kajiman', 'Horor', '1 Jam 40 M'),
('48', 'Galaxy 3', 'Action', '2 Jam 15 M');

-- --------------------------------------------------------

--
-- Table structure for table `tb061_jadwal`
--

CREATE TABLE `tb061_jadwal` (
  `Id_Jadwal` varchar(5) NOT NULL,
  `Id_Film` varchar(5) DEFAULT NULL,
  `Id_Studio` varchar(5) DEFAULT NULL,
  `Waktu_Mulai` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb061_jadwal`
--

INSERT INTO `tb061_jadwal` (`Id_Jadwal`, `Id_Film`, `Id_Studio`, `Waktu_Mulai`) VALUES
('05', '43', '30', '2023-05-25 15:30:00'),
('06', '44', '31', '2023-05-28 18:15:00'),
('07', '45', '32', '2023-05-27 08:30:00'),
('08', '46', '33', '2023-05-24 11:00:00'),
('09', '47', '34', '2023-05-22 13:50:00');

--
-- Triggers `tb061_jadwal`
--
DELIMITER $$
CREATE TRIGGER `after_update_jadwal` AFTER UPDATE ON `tb061_jadwal` FOR EACH ROW BEGIN
UPDATE Tb061_film
SET waktu_mulai = NEW.waktu_mulai
WHERE id_film = NEW.id_film;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb061_kursi`
--

CREATE TABLE `tb061_kursi` (
  `Id_Studio` varchar(5) DEFAULT NULL,
  `Nomor_Kursi` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb061_kursi`
--

INSERT INTO `tb061_kursi` (`Id_Studio`, `Nomor_Kursi`) VALUES
('30', 'A5'),
('31', 'B7'),
('32', 'C9'),
('33', 'D8'),
('34', 'E6');

-- --------------------------------------------------------

--
-- Table structure for table `tb061_penonton`
--

CREATE TABLE `tb061_penonton` (
  `Id_Penonton` varchar(5) NOT NULL,
  `Id_Jadwal` varchar(5) DEFAULT NULL,
  `Nama_Penonton` varchar(35) DEFAULT NULL,
  `Nomor_Telepon` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb061_penonton`
--

INSERT INTO `tb061_penonton` (`Id_Penonton`, `Id_Jadwal`, `Nama_Penonton`, `Nomor_Telepon`) VALUES
('14', '05', 'Varida', '0834568253'),
('15', '06', 'David', '0824584324'),
('16', '07', 'Zaskia', '0814556232'),
('17', '08', 'Fadly', '0876555420');

-- --------------------------------------------------------

--
-- Table structure for table `tb061_studio`
--

CREATE TABLE `tb061_studio` (
  `Id_Studio` varchar(5) NOT NULL,
  `Nama_Studio` varchar(35) DEFAULT NULL,
  `Kapasitas` int(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb061_studio`
--

INSERT INTO `tb061_studio` (`Id_Studio`, `Nama_Studio`, `Kapasitas`) VALUES
('30', 'Studio 1', 60),
('31', 'Studio 2', 55),
('32', 'Studio 3', 50),
('33', 'Studio 4', 55),
('34', 'Studio 5', 60);

--
-- Triggers `tb061_studio`
--
DELIMITER $$
CREATE TRIGGER `before_delete_studio` BEFORE DELETE ON `tb061_studio` FOR EACH ROW BEGIN
DECLARE jumlah_jadwal INT;
SELECT COUNT(*) INTO jumlah_jadwal
FROM Tb061_jadwal
WHERE id_studio = OLD.id_studio;
 IF jumlah_jadwal > 0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tidak dapat menghapus studio yang masih memiliki jadwal tayang';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb061_tiket`
--

CREATE TABLE `tb061_tiket` (
  `Id_Tiket` varchar(5) NOT NULL,
  `Id_Jadwal` varchar(5) DEFAULT NULL,
  `Nomor_Kursi` varchar(5) DEFAULT NULL,
  `Harga` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb061_tiket`
--

INSERT INTO `tb061_tiket` (`Id_Tiket`, `Id_Jadwal`, `Nomor_Kursi`, `Harga`) VALUES
('70', '05', 'A5', 'Rp50.000'),
('71', '06', 'B7', 'Rp50.000'),
('72', '07', 'C9', 'Rp50.000'),
('73', '08', 'D8', 'Rp50.000');

-- --------------------------------------------------------

--
-- Table structure for table `tb061_transaksi`
--

CREATE TABLE `tb061_transaksi` (
  `Id_Transaksi` varchar(5) NOT NULL,
  `Id_Tiket` varchar(5) DEFAULT NULL,
  `Total_Pembayaran` varchar(20) DEFAULT NULL,
  `Metode_Pembayaran` varchar(20) DEFAULT NULL,
  `Waktu_Transaksi` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tb061_transaksi`
--

INSERT INTO `tb061_transaksi` (`Id_Transaksi`, `Id_Tiket`, `Total_Pembayaran`, `Metode_Pembayaran`, `Waktu_Transaksi`) VALUES
('91', '70', 'Rp50.000', 'Cash', '2023-05-25'),
('92', '71', 'Rp50.000', 'Qris', '2023-05-26'),
('93', '72', 'Rp50.000', 'Dana', '2023-05-27'),
('94', '73', 'Rp50.000', 'Cash', '2023-05-28');

-- --------------------------------------------------------

--
-- Structure for view `detail_film_v`
--
DROP TABLE IF EXISTS `detail_film_v`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `detail_film_v`  AS SELECT `tb061_film`.`Judul` AS `judul`, `tb061_film`.`Genre` AS `genre`, `tb061_film`.`Durasi` AS `durasi`, `tb061_jadwal`.`Waktu_Mulai` AS `waktu_mulai` FROM (`tb061_film` join `tb061_jadwal` on(`tb061_film`.`Id_Film` = `tb061_jadwal`.`Id_Film`)) ;

-- --------------------------------------------------------

--
-- Structure for view `detail_tiket_v`
--
DROP TABLE IF EXISTS `detail_tiket_v`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `detail_tiket_v`  AS SELECT `tb061_film`.`Judul` AS `judul`, `tb061_jadwal`.`Waktu_Mulai` AS `waktu_mulai`, `tb061_tiket`.`Harga` AS `harga`, `tb061_transaksi`.`Total_Pembayaran` AS `total_pembayaran`, `tb061_transaksi`.`Metode_Pembayaran` AS `metode_pembayaran` FROM (((`tb061_film` join `tb061_jadwal` on(`tb061_film`.`Id_Film` = `tb061_jadwal`.`Id_Film`)) join `tb061_tiket` on(`tb061_tiket`.`Id_Jadwal` = `tb061_jadwal`.`Id_Jadwal`)) join `tb061_transaksi` on(`tb061_transaksi`.`Id_Tiket` = `tb061_tiket`.`Id_Tiket`)) ;

-- --------------------------------------------------------

--
-- Structure for view `jadwal_v`
--
DROP TABLE IF EXISTS `jadwal_v`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `jadwal_v`  AS SELECT `tb061_film`.`Judul` AS `judul`, `tb061_jadwal`.`Waktu_Mulai` AS `waktu_mulai`, `tb061_studio`.`Nama_Studio` AS `nama_studio` FROM ((`tb061_film` join `tb061_jadwal` on(`tb061_film`.`Id_Film` = `tb061_jadwal`.`Id_Film`)) join `tb061_studio` on(`tb061_jadwal`.`Id_Studio` = `tb061_studio`.`Id_Studio`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb061_film`
--
ALTER TABLE `tb061_film`
  ADD PRIMARY KEY (`Id_Film`);

--
-- Indexes for table `tb061_jadwal`
--
ALTER TABLE `tb061_jadwal`
  ADD PRIMARY KEY (`Id_Jadwal`),
  ADD KEY `Id_Film` (`Id_Film`),
  ADD KEY `Id_Studio` (`Id_Studio`);

--
-- Indexes for table `tb061_kursi`
--
ALTER TABLE `tb061_kursi`
  ADD PRIMARY KEY (`Nomor_Kursi`),
  ADD KEY `Id_Studio` (`Id_Studio`);

--
-- Indexes for table `tb061_penonton`
--
ALTER TABLE `tb061_penonton`
  ADD PRIMARY KEY (`Id_Penonton`),
  ADD KEY `Id_Jadwal` (`Id_Jadwal`);

--
-- Indexes for table `tb061_studio`
--
ALTER TABLE `tb061_studio`
  ADD PRIMARY KEY (`Id_Studio`);

--
-- Indexes for table `tb061_tiket`
--
ALTER TABLE `tb061_tiket`
  ADD PRIMARY KEY (`Id_Tiket`),
  ADD KEY `Nomor_Kursi` (`Nomor_Kursi`),
  ADD KEY `Id_Jadwal` (`Id_Jadwal`);

--
-- Indexes for table `tb061_transaksi`
--
ALTER TABLE `tb061_transaksi`
  ADD PRIMARY KEY (`Id_Transaksi`),
  ADD KEY `Id_Tiket` (`Id_Tiket`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tb061_jadwal`
--
ALTER TABLE `tb061_jadwal`
  ADD CONSTRAINT `tb061_jadwal_ibfk_1` FOREIGN KEY (`Id_Film`) REFERENCES `tb061_film` (`Id_Film`),
  ADD CONSTRAINT `tb061_jadwal_ibfk_2` FOREIGN KEY (`Id_Studio`) REFERENCES `tb061_studio` (`Id_Studio`);

--
-- Constraints for table `tb061_kursi`
--
ALTER TABLE `tb061_kursi`
  ADD CONSTRAINT `tb061_kursi_ibfk_1` FOREIGN KEY (`Id_Studio`) REFERENCES `tb061_studio` (`Id_Studio`);

--
-- Constraints for table `tb061_penonton`
--
ALTER TABLE `tb061_penonton`
  ADD CONSTRAINT `tb061_penonton_ibfk_1` FOREIGN KEY (`Id_Jadwal`) REFERENCES `tb061_jadwal` (`Id_Jadwal`);

--
-- Constraints for table `tb061_tiket`
--
ALTER TABLE `tb061_tiket`
  ADD CONSTRAINT `tb061_tiket_ibfk_1` FOREIGN KEY (`Nomor_Kursi`) REFERENCES `tb061_kursi` (`Nomor_Kursi`),
  ADD CONSTRAINT `tb061_tiket_ibfk_2` FOREIGN KEY (`Id_Jadwal`) REFERENCES `tb061_jadwal` (`Id_Jadwal`);

--
-- Constraints for table `tb061_transaksi`
--
ALTER TABLE `tb061_transaksi`
  ADD CONSTRAINT `tb061_transaksi_ibfk_1` FOREIGN KEY (`Id_Tiket`) REFERENCES `tb061_tiket` (`Id_Tiket`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
