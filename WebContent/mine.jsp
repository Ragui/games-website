<%@page import="java.awt.Button"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Random" %>

<%!
	public class table{
		private int Width = 0, Height = 0, Mines = 0;
		private int t[][];
		private boolean b[][];
		
		public table(int x,int y,int z){
			Width = x;
			Height = y;
			Mines = z;
			t = new int[x][y];
			b = new boolean[x][y];
			initial(x,y);
			generateMines(z);
			setTable(x,y);
		}
		
		public int getCell(int x,int y){
			return t[x][y];
		}
		
		private void initial(int x, int y){
			for(int i = 0; i < x; i++){
				for(int j = 0; j < y; j++ ){
					t[i][j] = 0;
					b[i][j] = false;
				}
			}
		}
		
		private void generateMines(int m){
			Random rand = new Random();
			int x, y, count = 0;
			while(count < m){
				x = rand.nextInt(Width);
				y = rand.nextInt(Height);
				if(t[x][y] != -1){
					t[x][y] = -1;
					count++;
				}
			}
		}
		
		private void setTable(int x, int y){
			int value = 0;
			for(int i = 0; i < x; i++){
				for( int j = 0; j < y; j++){
					if(t[i][j] != -1){
						if(i-1 >= 0 && j-1 >= 0 && t[i-1][j-1] == -1){
							value++;
						}
						if(i-1 >= 0  && t[i-1][j] == -1){
							value++;
						}
						if(i-1 >= 0 && j+1 < y && t[i-1][j+1] == -1){
							value++;
						}
						if(j-1 >= 0 && t[i][j-1] == -1){
							value++;
						}
						if(j+1 < y && t[i][j+1] == -1){
							value++;
						}
						if(i+1 < x && j-1 >= 0 && t[i+1][j-1] == -1){
							value++;
						}
						if(i+1 < x && t[i+1][j] == -1){
							value++;
						}
						if(i+1 < x && j+1 < y && t[i+1][j+1] == -1){
							value++;
						}
						t[i][j] = value;
						value = 0;
					}
				}
			}
		}
		
		public void update(int x,int y){
			b[x][y] = true;
		}
		
		public boolean getShow(int x,int y){
			return b[x][y];
		}
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Minesweeper</title>
</head>
<body>

<form method="post">
	<input type="hidden" value="1" name="fnId">
	Width: <input type="number" name="Width">
	Height: <input type="number" name="Height">
	Mines: <input type="number" name="Mines">
	<input type="submit" value="Go"/>
</form>
<%!
	int W = 0;
	int H = 0;
	int M = 0;
	table board = null;
	
	public String printBoard(){
		String res = "";
		res += ("<form method=\"submit\" name=\"fr\">"+
				"<input type=\"hidden\" name=\"hd\">");
		for(int i = 0; i < W; i++){
			for(int j = 0; j < H; j++ ){
				if(board.getShow(i,j) == false){
				int z = i*W+j;
				res += ("<input type=\"button\" width=\"20\" height=\"20\" onClick=\""+
			"{document.fr.hd.value ="+z+"; document.fr.submit();}\">");
			}
				else{
					res += "<div style=\"width:20; height:20;\" placeholder=\"h\">";
//						+board.getCell(i, j)+"\"/>";
				}
			}
			res += ("<br>");	
		}
		res += ("</form>");
		return res;
	}
%>
<%	
	if(request.getParameter("fnId") != null){
		String w = request.getParameter("Width");
		String h = request.getParameter("Height");
		String m = request.getParameter("Mines");
		W = Integer.parseInt(w);
		H = Integer.parseInt(h);
		M = Integer.parseInt(m);
		board = new table(W,H,M);
		out.print(printBoard());
	}
	
	if(request.getParameter("hd") != null){
		String v = request.getParameter("hd");
		int z = Integer.parseInt(v);
		int x = z / W;
		int y = z % W;
		board.update(x, y);
		out.print(printBoard());
	}
		
%>

</body>
</html>