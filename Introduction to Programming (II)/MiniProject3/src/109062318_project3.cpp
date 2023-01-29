#include <iostream>
#include <fstream>
#include <array>
#include <vector>
#include <cstdlib>
#include <ctime>

struct Point {
    int x, y;
	Point() : Point(0, 0) {}
	Point(int x, int y) : x(x), y(y) {}
	bool operator==(const Point& rhs) const {
		return x == rhs.x && y == rhs.y;
	}
	bool operator!=(const Point& rhs) const {
		return !operator==(rhs);
	}
	Point operator+(const Point& rhs) const {
		return Point(x + rhs.x, y + rhs.y);
	}
	Point operator-(const Point& rhs) const {
		return Point(x - rhs.x, y - rhs.y);
	}
};

int player;
const int SIZE = 8;
std::array<std::array<int, SIZE>, SIZE> board;
std::vector<Point> next_valid_spots;

void read_board(std::ifstream& fin) {
    fin >> player;
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            fin >> board[i][j];
        }
    }
}

void read_valid_spots(std::ifstream& fin) {
    int n_valid_spots;
    fin >> n_valid_spots;
    int x, y;
    for (int i = 0; i < n_valid_spots; i++) {
        fin >> x >> y;
        next_valid_spots.push_back({x, y});
    }
}

void write_valid_spot(Point p,std::ofstream& fout) {
    /*int n_valid_spots = next_valid_spots.size();
    srand(time(NULL));
    // Choose random spot. (Not random uniform here)
    int index = (rand() % n_valid_spots);
    Point p = next_valid_spots[index];*/

    
    // Remember to flush the output to ensure the last action is written to file.
    fout << p.x << " " << p.y << std::endl;
    fout.flush();
}
class OthelloBoard {
public:
    enum SPOT_STATE {
        EMPTY = 0,
        BLACK = 1,
        WHITE = 2
    };
    static const int SIZE = 8;
    const std::array<Point, 8> directions{{
        Point(-1, -1), Point(-1, 0), Point(-1, 1),
        Point(0, -1), /*{0, 0}, */Point(0, 1),
        Point(1, -1), Point(1, 0), Point(1, 1)
    }};
    std::array<std::array<int, SIZE>, SIZE> board;
    std::vector<Point> next_valid_spots;
    std::array<int, 3> disc_count;
    int cur_player;
    bool done;
    int winner;
private:
    int get_next_player(int player) const {
        return 3 - player;
    }
    bool is_spot_on_board(Point p) const {
        return 0 <= p.x && p.x < SIZE && 0 <= p.y && p.y < SIZE;
    }
    int get_disc(Point p) const {
        return board[p.x][p.y];
    }
    void set_disc(Point p, int disc) {
        board[p.x][p.y] = disc;
    }
    bool is_disc_at(Point p, int disc) const {
        if (!is_spot_on_board(p))
            return false;
        if (get_disc(p) != disc)
            return false;
        return true;
    }
    bool is_spot_valid(Point center) const {
        if (get_disc(center) != EMPTY)
            return false;
        for (Point dir: directions) {
            // Move along the direction while testing.
            Point p = center + dir;
            if (!is_disc_at(p, get_next_player(cur_player)))
                continue;
            p = p + dir;
            while (is_spot_on_board(p) && get_disc(p) != EMPTY) {
                if (is_disc_at(p, cur_player))
                    return true;
                p = p + dir;
            }
        }
        return false;
    }
    void flip_discs(Point center) {
        for (Point dir: directions) {
            // Move along the direction while testing.
            Point p = center + dir;
            if (!is_disc_at(p, get_next_player(cur_player)))
                continue;
            std::vector<Point> discs({p});
            p = p + dir;
            while (is_spot_on_board(p) && get_disc(p) != EMPTY) {
                if (is_disc_at(p, cur_player)) {
                    for (Point s: discs) {
                        set_disc(s, cur_player);
                    }
                    disc_count[cur_player] += discs.size();
                    disc_count[get_next_player(cur_player)] -= discs.size();
                    break;
                }
                discs.push_back(p);
                p = p + dir;
            }
        }
    }
public:
    OthelloBoard(std::array<std::array<int, SIZE>, SIZE> new_board, int player) {
         board = new_board;
         cur_player = player;
         next_valid_spots = get_valid_spots();
         done = false;
         for(int i = 0 ; i < 8 ; i++){
            for(int q = 0 ; q < 8 ; q++){
                disc_count[board[i][q]]++;
            }
         }
    }
    std::vector<Point> get_valid_spots() const {
        std::vector<Point> valid_spots;
        for (int i = 0; i < SIZE; i++) {
            for (int j = 0; j < SIZE; j++) {
                Point p = Point(i, j);
                if (board[i][j] != EMPTY)
                    continue;
                if (is_spot_valid(p))
                    valid_spots.push_back(p);
            }
        }
        return valid_spots;
    }
    bool put_disc(Point p) {
        set_disc(p, cur_player);
        disc_count[cur_player]++;
        disc_count[EMPTY]--;
        flip_discs(p);
        // Give control to the other player.
        cur_player = get_next_player(cur_player);
        next_valid_spots = get_valid_spots();
        // Check Win
        if (next_valid_spots.size() == 0) {
            cur_player = get_next_player(cur_player);
            next_valid_spots = get_valid_spots();
            if (next_valid_spots.size() == 0) {
                // Game ends
                done = true;
                int white_discs = disc_count[WHITE];
                int black_discs = disc_count[BLACK];
                if (white_discs == black_discs) winner = EMPTY;
                else if (black_discs > white_discs) winner = BLACK;
                else winner = WHITE;
            }
        }
        return true;
    }
};

int value(OthelloBoard now,int player){
    int i,j,k;
    //w:weight, c:corner, nc:near corner, o:open(mobility), a:available
    int heuristic=0,w=0,c=0,nc=0,o=0,a=0;
    int mytile=0,opptile=0;

    int weight[8][8]={   
        {500, -25,  10,   5,   5,  10, -25, 500},
        {-25,-100,   1,   1,   1,   1,-100, -25},
        {10 ,   1,   3,   2,   2,   3,   1,  10},
        {5  ,   1,   2,   1,   1,   2,   1,   5},
        {5  ,   1,   2,   1,   1,   2,   1,   5},
        {10 ,   1,   3,   2,   2,   3,   1,  10},
        {-25,-100,   1,   1,   1,   1,-100, -25},
        {500, -25,  10,   5,   5,  10, -25, 500}
    };
    Point corner[4]={Point(0,0),Point(0,7),Point(7,0),Point(7,7)};
    Point dir[8]={
        Point(-1,-1), Point(-1,0), Point(-1,1),
        Point(0, -1),              Point(0, 1),
        Point(1, -1), Point(1, 0), Point(1, 1)
    };

    //weight,open(mobility)
    for(i=0;i<8;i++){
        for(j=0;j<8;j++){
            if(now.board[i][j] == player){
                w += weight[i][j];
                for(k=0;k<8;k++){
                    Point p = Point(i,j) + dir[k];
                    if(0 <= p.x && p.x < SIZE && 0 <= p.y && p.y < SIZE && now.board[p.x][p.y] == 0){
                        mytile++;
                    }
                }
            }else if(now.board[i][j] == 3-player){
                w -= weight[i][j];
                for(k=0;k<8;k++){
                    Point p = Point(i,j) + dir[k];
                    if(0 <= p.x && p.x < SIZE && 0 <= p.y && p.y < SIZE && now.board[p.x][p.y] == 0){
                        opptile++;
                    }
                }
            }
        }
    }
    o = opptile - mytile;

    //corner,near corner
    mytile=opptile=0;
    for(auto p:corner){
        if(now.board[p.x][p.y]==player){
            mytile++;
        }else if(now.board[p.x][p.y]==3-player){
            opptile++;
        }else{
            for(k=0;k<8;k++){
                Point p = Point(i,j) + dir[k];
                if(0 <= p.x && p.x < SIZE && 0 <= p.y && p.y < SIZE){
                    if(now.board[p.x][p.y] == player){
                        nc--;
                    }else if(now.board[p.x][p.y] == 3-player){
                        nc++;
                    }
                }
            }
        }
    }
    c = mytile - opptile;

    //available spot to put
    mytile=opptile=0;
    int originplayer = now.cur_player;

    now.cur_player = player;
	mytile = now.get_valid_spots().size();

    now.cur_player = 3 - player;
	opptile = now.get_valid_spots().size();

    now.cur_player = originplayer;

    a = mytile - opptile;

    heuristic = 20 * w + 10 * o + 30 * nc + 100 * c + 70 * a;
    return heuristic;
}
int alphabeta(OthelloBoard now,int depth,int alpha,int beta,bool minmax,std::ofstream& fout){
    int i;
    int nowval,abval,choose_idx;

    if(depth==5 || now.done){
        return value(now,player);
    }
    if(minmax){ //on player node
        nowval=-1e9;
        for(i=0;i < (int)now.next_valid_spots.size();i++){
            OthelloBoard next = now;
            next.put_disc(now.next_valid_spots[i]);
            abval = alphabeta(next , depth+1 , alpha , beta , false , fout);
            nowval = std::max(nowval , abval);
            alpha = std::max(alpha , nowval);

            if(nowval==abval){
                choose_idx=i;
            }
            if(alpha>=beta){
                break;
            }
        }
    }else{  //on opponent node
        nowval=1e9;
        for(i=0;i < (int)now.next_valid_spots.size();i++){
            OthelloBoard next = now;
            next.put_disc(now.next_valid_spots[i]);
            abval = alphabeta(next , depth+1 , alpha , beta , true , fout);
            nowval = std::min(nowval , abval);
            beta = std::min(beta , nowval);
            if(alpha>=beta){
                break;
            }
        }
        
    }
    if(depth == 0){
        /*int x=now.next_valid_spots[choose_idx].x;
        int y=now.next_valid_spots[choose_idx].y;
        std::cout<<"gonna put "<<"("<<x<<","<<y<<")\n";*/
        write_valid_spot(now.next_valid_spots[choose_idx], fout);
    }
    return nowval;
}

int main(int, char** argv) {
    srand(time(NULL));
    std::ifstream fin(argv[1]);
    std::ofstream fout(argv[2]);
    read_board(fin);
    read_valid_spots(fin);

    OthelloBoard now(board,player);
    alphabeta(now,0,-1e9,1e9,true,fout);
    
    //write_valid_spot(fout);
    fin.close();
    fout.close();
    return 0;
}