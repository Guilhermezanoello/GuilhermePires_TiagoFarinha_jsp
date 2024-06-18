<%
Connection conn = null;

Class.forName("com.mysql.jdbc.Driver").newInstance();
// Link para a base de dados
String jdbcURL = "jdbc:mysql://localhost:3306/formaest2";
conn = DriverManager.getConnection(jdbcURL, "root", "");

// Variaveis a ser utilizadas para correr querys e armazenar resultados
PreparedStatement ps = null;
ResultSet rs = null;

PreparedStatement psTipo = null;
ResultSet rsTipo = null;

PreparedStatement psDocente = null;
ResultSet rsDocente = null;

PreparedStatement psTipoCurso = null;
ResultSet rsTipoCurso = null;

PreparedStatement psEstado = null;
ResultSet rsEstado = null;

PreparedStatement psAluno = null;
ResultSet rsAluno = null;

PreparedStatement psTituloCurso = null;
ResultSet rsTituloCurso = null;

PreparedStatement psStatusInscricao = null;
ResultSet rsStatusInscricao = null;

PreparedStatement psCount = null;
ResultSet rsCount = null;

PreparedStatement psLimite = null;
ResultSet rsLimite = null;

PreparedStatement psVerificar = null;
ResultSet rsVerificar = null;

PreparedStatement psInserir = null;
ResultSet rsInserir = null;

PreparedStatement psImagem = null;
ResultSet rsImagem = null;
%>