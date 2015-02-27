import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
public static final int NUM_ROWS=20;
public static final int NUM_COLS=20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs=new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

int totalBombs=50;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons=new MSButton[NUM_ROWS][NUM_COLS];
    for (int i=0; i<NUM_ROWS; i++){
        for (int p=0; p<NUM_COLS; p++){
            buttons[i][p]=new MSButton(i,p);
        }
    }

    //declare and initialize buttons
    setBombs();
}
public void setBombs()
{
    for (int i=0; i<totalBombs; i++){
        int row=(int)(Math.random()*20);
        int colume=(int)(Math.random()*20);
        if (!bombs.contains(buttons[row][colume])){
            bombs.add(buttons[row][colume]);
        }
    }

}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int count=0;
    for (int i=0; i<NUM_ROWS; i++){
        for (int p=0; p<NUM_COLS; p++){
            if (bombs.contains(buttons[p][i]) && buttons[p][i].isMarked()){
                count++;
            }
        }
    }
    if (count==totalBombs){
        return true;
    }
    return false;
}
public void displayLosingMessage()
{
    for (int i=0; i<NUM_ROWS; i++){
        for (int p=0; p<NUM_COLS; p++){
            if (bombs.contains(buttons[p][i])){
                buttons[p][i].clicked=true;
                buttons[p][i].draw();
            }
        }
    }

    for (int i=0; i<NUM_ROWS; i++){
        for (int p=0; p<NUM_COLS; p++){
            buttons[p][i].label="";
        }
    }
    buttons[10][6].label="Y";
    buttons[10][7].label="O";
    buttons[10][8].label="U";
    buttons[10][9].label="";
    buttons[10][10].label="L";
    buttons[10][11].label="O";
    buttons[10][12].label="S";
    buttons[10][13].label="E";
    buttons[10][14].label="!";
}
public void displayWinningMessage()
{
    for (int i=0; i<NUM_ROWS; i++){
        for (int p=0; p<NUM_COLS; p++){
            buttons[p][i].label="";
        }
    }
    buttons[10][6].label="Y";
    buttons[10][7].label="O";
    buttons[10][8].label="U";
    buttons[10][9].label="";
    buttons[10][10].label="W";
    buttons[10][11].label="O";
    buttons[10][12].label="N";
    buttons[10][13].label="!";
    buttons[10][14].label="!";
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if (keyPressed==true){
            marked = !marked;     
        }
        else if(bombs.contains(this)){
            displayLosingMessage();
        }
        else if(countBombs(r,c)>0){
            label="" + (countBombs(r,c));
        }
        else {
            if (isValid(r-1,c-1) && !buttons[r-1][c-1].isClicked()){
                buttons[r-1][c-1].mousePressed();
            }
            if (isValid(r+1,c+1) && !buttons[r+1][c+1].isClicked()){
                buttons[r+1][c+1].mousePressed();
            }
            if (isValid(r-1,c+1) && !buttons[r-1][c+1].isClicked()){
                buttons[r-1][c+1].mousePressed();
            }
            if (isValid(r+1,c-1) && !buttons[r+1][c-1].isClicked()){
                buttons[r+1][c-1].mousePressed();
            }
            if (isValid(r,c+1) && !buttons[r][c+1].isClicked()){
                buttons[r][c+1].mousePressed();
            }
            if (isValid(r,c-1) && !buttons[r][c-1].isClicked()){
                buttons[r][c-1].mousePressed();
            }
            if (isValid(r+1,c) && !buttons[r+1][c].isClicked()){
                buttons[r+1][c].mousePressed();
            }
            if (isValid(r-1,c) && !buttons[r-1][c].isClicked()){
                buttons[r-1][c].mousePressed();
            }
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
        fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if (r>-1 && r<20 && c>-1 && c<20){
            return true;
        }
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        
        for (int i=row-1; i<row+2; i++){
            for (int p=col-1; p<col+2; p++){
                if (isValid(i,p)){
                    if (bombs.contains(buttons[i][p])){
                        numBombs++;
                    }
                }
            }
        }

        return numBombs;
    }
}
