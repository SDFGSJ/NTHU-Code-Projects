#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>

#include<allegro5/allegro.h>
#include<allegro5/allegro_primitives.h>
#include<allegro5/allegro_image.h>
#include<allegro5/allegro_font.h>
#include<allegro5/allegro_ttf.h>
#include<allegro5/allegro_audio.h>
#include<allegro5/allegro_acodec.h>

//If defined, logs will be shown on console and written to file.
//If commented out, logs will not be shown nor be saved.
#define LOG_ENABLED

/*Constants*/

//Frame rate (frame per second)
const int FPS = 60;
const int SCREEN_W = 1000;
const int SCREEN_H = 800;
//At most 10 audios can be played at a time.
const int RESERVE_SAMPLES = 10;
//Same as:
//const int SCENE_MENU = 1;
//const int SCENE_START = 2;
/*Declare a new scene id*/
enum{
    SCENE_MENU = 1,
    SCENE_START = 2,
    SCENE_SETTINGS = 3,
	SCENE_YOUDEAD = 4,
	SCENE_INFOR = 5,
	SCENE_YOUWIN = 6,
	SCENE_BOSS = 7
};

/*Input states*/

// The active scene id.
int active_scene;
// Keyboard state, whether the key is down or not.
bool key_state[ALLEGRO_KEY_MAX];
// Mouse state, whether the key is down or not.
// 1:left, 2:right, 3:middle.
bool *mouse_state;
// Mouse position.
int mouse_x, mouse_y;

//my variables
int beat_count, score, haveplayed, win;

/* Variables for allegro basic routines. */
ALLEGRO_DISPLAY* game_display;
ALLEGRO_EVENT_QUEUE* game_event_queue;
ALLEGRO_TIMER* game_update_timer;

/*Shared resources*/
ALLEGRO_FONT* font_pirulen_32;
ALLEGRO_FONT* font_pirulen_24;
ALLEGRO_FONT* font_pirulen_16;

/*Menu Scene resources*/
ALLEGRO_BITMAP* main_img_background;
ALLEGRO_BITMAP* start_img_background;
ALLEGRO_BITMAP* win_img_background;
ALLEGRO_BITMAP* boss_img_background;
ALLEGRO_BITMAP* img_settings;
ALLEGRO_BITMAP* img_settings2;
ALLEGRO_BITMAP* img_information;
ALLEGRO_BITMAP* img_information_lighter;
ALLEGRO_BITMAP* img_backbutton;
ALLEGRO_BITMAP* img_backbuttonlighter;

/*other sound effect*/
ALLEGRO_SAMPLE* main_bgm;
ALLEGRO_SAMPLE_ID main_bgm_id;
ALLEGRO_SAMPLE* start_bgm;
ALLEGRO_SAMPLE_ID start_bgm_id;
ALLEGRO_SAMPLE* shoot_bgm;
ALLEGRO_SAMPLE_ID shoot_bgm_id;
ALLEGRO_SAMPLE* level_completed_bgm;
ALLEGRO_SAMPLE_ID level_completed_bgm_id;
ALLEGRO_SAMPLE* powerup_bgm;
ALLEGRO_SAMPLE_ID powerup_bgm_id;
ALLEGRO_SAMPLE* losing_bgm;
ALLEGRO_SAMPLE_ID losing_bgm_id;
ALLEGRO_SAMPLE* minus_blood_bgm;
ALLEGRO_SAMPLE_ID minus_blood_bgm_id;
ALLEGRO_SAMPLE* enemy_dead_bgm;
ALLEGRO_SAMPLE_ID enemy_dead_bgm_id;
ALLEGRO_SAMPLE* eataddhp_bgm;
ALLEGRO_SAMPLE_ID eataddhp_bgm_id;
ALLEGRO_SAMPLE* boss_bgm;
ALLEGRO_SAMPLE_ID boss_bgm_id;

/* Start Scene resources*/
ALLEGRO_BITMAP* img_addhp;
ALLEGRO_BITMAP* img_minushp;
ALLEGRO_BITMAP* start_img_plane;
ALLEGRO_BITMAP* start_img_enemy;
ALLEGRO_BITMAP* img_bullet;
ALLEGRO_BITMAP* img_rocket1;
ALLEGRO_BITMAP* img_rocket2;
ALLEGRO_BITMAP* img_tank;
ALLEGRO_BITMAP* img_boss;
ALLEGRO_BITMAP* img_boss_bullet;
//ALLEGRO_BITMAP* img_dongyong;


typedef struct{
    //The "center" coordinate of the image.
    float x, y;
    float w, h;
    float vx, vy;
    int hp;
    bool hidden;
    ALLEGRO_BITMAP* img;
}MovableObject;

void draw_movable_object(MovableObject obj);
#define LIFE 3
#define BOSS_LIFE 100
#define ENEMY_POINT 10
#define TANK_POINT 5
#define POWERUP_COUNT 6
#define BOSS_POINT 70
#define BOSS_SPEED 8
#define MAX_POISON 5
#define MAX_BULLET 8
#define MAX_POWERUP_BULLET 24
#define MAX_ENEMY 3
#define MAX_ENEMY_BULLET 3
#define MAX_TANK 3
#define MAX_TANK_BULLET 3
#define MAX_BOSS_BULLET 100
#define BOSS_BULLET_SPEED 5
MovableObject rocket1,rocket2;
MovableObject addhp;
MovableObject minushp[MAX_POISON];
MovableObject plane;
MovableObject bullets[MAX_BULLET];
MovableObject powerup_bullets[MAX_POWERUP_BULLET];
MovableObject enemies[MAX_ENEMY];
MovableObject enemies_bullet[MAX_ENEMY_BULLET];
MovableObject tank[MAX_TANK];
MovableObject tank_bullet[MAX_TANK_BULLET];
MovableObject boss;
MovableObject boss_bullet[MAX_BOSS_BULLET];
//MovableObject dong;

const float MAX_ADDHP_COOLDOWN = 15.0f;
const float MAX_MINUSHP_COOLDOWN = 0.7f;
const float MAX_COOLDOWN = 0.2f;
const float MAX_ENEMY_COOLDOWN = 0.7f;
const float MAX_TANK_COOLDOWN = 0.7f;
const float MAX_BOSS_COOLDOWN = 0.1f;
double last_addhp_timestamp;
double last_minushp_timestamp;
double last_shoot_timestamp;
double last_enemyshoot_timestamp;
double last_tankshoot_timestamp;
double last_bossshoot_timestamp;

/*Declare function prototypes*/

// Initialize allegro5 library
void allegro5_init(void);
// Initialize variables and resources.
// Allows the game to perform any initialization it needs before starting to run.
void game_init(void);
// Process events inside the event queue using an infinity loop.
void game_start_event_loop(void);
// Run game logic such as updating the world, checking for collision,
// switching scenes and so on.
// This is called when the game should update its logic.
void game_update(void);
// Draw to display.
// This is called when the game should draw itself.
void game_draw(void);
void game_destroy(void);
void game_change_scene(int next_scene);
// Load resized bitmap and check if failed.
ALLEGRO_BITMAP *load_bitmap_resized(const char *filename, int w, int h);

bool pnt_in_rect(int px, int py, int x, int y, int w, int h);

/* Event callbacks. */
void on_key_down(int keycode);
void on_mouse_down(int btn, int x, int y);

/* Declare function prototypes for debugging. */

// Display error message and exit the program, used like 'printf'.
// Write formatted output to stdout and file from the format string.
void game_abort(const char* format, ...);
// Log events for later debugging, used like 'printf'.
// Write formatted output to stdout and file from the format string.
// You can inspect "log.txt" for logs in the last run.
void game_log(const char* format, ...);
// Log using va_list.
void game_vlog(const char* format, va_list arg);

/*---------------------------my function--------------------------------------*/
void draw_plane(void)
{
	//plane
    plane.vx = plane.vy = 0;
    if (key_state[ALLEGRO_KEY_UP] || key_state[ALLEGRO_KEY_W])
        plane.vy -= 1.5;
    if (key_state[ALLEGRO_KEY_DOWN] || key_state[ALLEGRO_KEY_S])
        plane.vy += 1.5;
    if (key_state[ALLEGRO_KEY_LEFT] || key_state[ALLEGRO_KEY_A])
        plane.vx -= 1.5;
    if (key_state[ALLEGRO_KEY_RIGHT] || key_state[ALLEGRO_KEY_D])
        plane.vx += 1.5;
    // 0.71 is (1/sqrt(2)).
    plane.y += plane.vy * 4 * (plane.vx ? 0.71f : 1);
    plane.x += plane.vx * 4 * (plane.vy ? 0.71f : 1);
    //Limit the plane inside the frame.
    if (plane.x - plane.w/2 < 0)
        plane.x = plane.w/2;
    else if (plane.x + plane.w/2 > SCREEN_W)
    	plane.x = SCREEN_W - plane.w/2;
    if (plane.y - plane.h/2 < 0)
        plane.y = plane.h/2;
    else if (plane.y + plane.h/2 > SCREEN_H)
        plane.y = SCREEN_H - plane.h/2;
}
void draw_bullet(void)
{
	// 1) For each bullets, if it's not hidden, update x, y according to vx, vy.
    // 2) If the bullet is out of the screen, hide it.
	int i;
	for(i=0;i<MAX_BULLET;i++){
        if(bullets[i].hidden)
            continue;
        bullets[i].x += bullets[i].vx;
        bullets[i].y += bullets[i].vy;
        if (bullets[i].y < 0)
            bullets[i].hidden = true;
    }
    
	for(i=0;i<MAX_POWERUP_BULLET;i++){
        if(powerup_bullets[i].hidden)
            continue;
        powerup_bullets[i].x += powerup_bullets[i].vx;
        powerup_bullets[i].y += powerup_bullets[i].vy;
        if (powerup_bullets[i].y < 0)
            powerup_bullets[i].hidden = true;
    }
}
void draw_addhp(void)
{
	double now = al_get_time();
	if(addhp.hidden){
		if(now - last_addhp_timestamp >= MAX_ADDHP_COOLDOWN){
			addhp.hidden=false;
        	last_addhp_timestamp = now;
        	addhp.x=(float)rand() / RAND_MAX * (SCREEN_W - addhp.w);
        	addhp.y=100;
		}
	}else{
		addhp.x += addhp.vx;
		addhp.y += addhp.vy;
		if(addhp.y > SCREEN_H)
			addhp.hidden = true;
		/*如果addhp超界就反彈*/
		if(addhp.x - addhp.w/2 <= 0 || addhp.x + addhp.w/2 >= SCREEN_W)
			addhp.vx *= -1;
	}
}
void draw_minushp(void)
{
	int i;
	double now = al_get_time();
	for(i=0;i<MAX_POISON;i++){
		if(minushp[i].hidden){
			if(now - last_minushp_timestamp >= MAX_MINUSHP_COOLDOWN){
				minushp[i].hidden = false;
	        	last_minushp_timestamp = now;
	        	minushp[i].x = (float)rand() / RAND_MAX * (SCREEN_W - minushp[i].w);
	        	minushp[i].y = 100;
			}
		}else{
			minushp[i].x += minushp[i].vx;
			minushp[i].y += minushp[i].vy;
			if(minushp[i].y > SCREEN_H)
				minushp[i].hidden = true;
			/*如果minushp超界就反彈*/ 
			if(minushp[i].x - minushp[i].w/2 <= 0 || minushp[i].x + minushp[i].w/2 >= SCREEN_W)
				minushp[i].vx *= -1;
		}
	}
}
void draw_enemy(void)
{
	int i;
	//enemy
    for(i=0;i<MAX_ENEMY;i++){
    	if(enemies[i].hidden){
    		enemies[i].hidden=false;
    		enemies[i].x = enemies[i].w / 2 + (float)rand() / RAND_MAX * (SCREEN_W - enemies[i].w);
            enemies[i].y = 50;
            enemies[i].vy = 1.5;
            enemies[i].hp = 2;
		}else{
			enemies[i].vx = 2 * cos(enemies[i].y/20);
			enemies[i].x += enemies[i].vx;
			enemies[i].y += enemies[i].vy;
			/*敵人出界 || 敵人生命值<=0*/
			if(enemies[i].y - enemies[i].h/2 > SCREEN_H || enemies[i].hp <= 0){
				if(enemies[i].hp <= 0){
					beat_count++;
					score+=ENEMY_POINT;
					al_play_sample(enemy_dead_bgm, 3, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &enemy_dead_bgm_id);
				}
				enemies[i].hidden = true;
			}
			/*碰到邊界反彈*/
			if(enemies[i].x - enemies[i].w/2 <= 0){
				enemies[i].x = enemies[i].w/2;
			}else if(enemies[i].x + enemies[i].w/2 >= SCREEN_W){
				enemies[i].x = SCREEN_W-enemies[i].w/2;
			}
		}
	}
	
	//tank
	for(i=0;i<MAX_TANK;i++){
		if(tank[i].hidden){
			tank[i].hidden = false;
			tank[i].hp = 1;
			tank[i].x = tank[i].w / 2 + (float)rand() / RAND_MAX * (SCREEN_W - tank[i].w);
			tank[i].y = 50;
			tank[i].vx = 2*( (float)rand() / RAND_MAX )-1;
			tank[i].vy = 1.5;
		}else{
			tank[i].x += tank[i].vx;
			tank[i].y += tank[i].vy;
			//敵人出界 || 敵人生命值<=0
			if(tank[i].y - tank[i].h/2 > SCREEN_H || tank[i].hp <= 0){
				if(tank[i].hp <= 0){
					beat_count++;
					score+=TANK_POINT;
					al_play_sample(enemy_dead_bgm, 3, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &enemy_dead_bgm_id);
				}
				tank[i].hidden = true;
			}
			//碰到邊界反彈
			if(tank[i].x - tank[i].w/2 <= 0 || tank[i].x + tank[i].w/2 >= SCREEN_W){
				tank[i].vx *= -1;
			}
		}
	}
}
void draw_enemy_bullet(void)
{
	int i;
	//enemy
	for(i=0;i<MAX_ENEMY_BULLET;i++){
		if(enemies_bullet[i].hidden){
			continue;
		}
		enemies_bullet[i].y += enemies_bullet[i].vy;
		if(enemies_bullet[i].y - enemies_bullet[i].h/2 > SCREEN_H)
			enemies_bullet[i].hidden = true;
	}
	
	//tank
	for(i=0;i<MAX_TANK_BULLET;i++){
		if(tank_bullet[i].hidden){
			continue;
		}
		tank_bullet[i].y += tank_bullet[i].vy;
		if(tank_bullet[i].y - tank_bullet[i].h/3 > SCREEN_H)
			tank_bullet[i].hidden = true;
	}
}
void draw_boss(void)
{
	if(boss.hidden){
		boss.hidden = false;
		boss.x = SCREEN_W/2;	//boss.w / 2 + (float)rand() / RAND_MAX * (SCREEN_W - boss.w);
		boss.y = 180;
		boss.vx = BOSS_SPEED;
	}else{
		boss.x += boss.vx;
		/*boss碰到邊界就反彈*/ 
		if(boss.x + boss.w/2 > SCREEN_W || boss.x-boss.w/2<=0){
			boss.vx *= -1;
		}
		if(boss.hp <= 0){
			boss.hidden = true;
			game_change_scene(SCENE_YOUWIN);
		}
	}
}
void draw_boss_bullet(void)
{
	int i;
	for(i=0;i<MAX_BOSS_BULLET;i++){
		if(boss_bullet[i].hidden){
			continue;
		}
		boss_bullet[i].y += boss_bullet[i].vy;
		if(boss_bullet[i].y - boss_bullet[i].h/2 > SCREEN_H)
			boss_bullet[i].hidden = true;
	}
}
void addhp_touch_you(void)
{
	if(abs(addhp.x - plane.x) <= plane.w/2 && abs(addhp.y - plane.y) <= plane.h/2){
		if(!addhp.hidden){
			al_play_sample(eataddhp_bgm, 2, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &eataddhp_bgm_id);
			plane.hp++;
			printf("plane hp=%d\n",plane.hp);
			addhp.hidden = true;
		}
	}
}
void minushp_touch_you(void)
{
	int i;
	for(i=0;i<MAX_POISON;i++){
		if(abs(minushp[i].x - plane.x) <= plane.w/2 && abs(minushp[i].y - plane.y) <= plane.h/2){
			if(!minushp[i].hidden){
				al_play_sample(minus_blood_bgm, 1, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &minus_blood_bgm_id);
				plane.hp--;
				printf("plane hp=%d\n",plane.hp);
				minushp[i].hidden = true;
			}
		}
	}
}
void enemy_touch_you(void)
{
	int i;
	/*敵人碰到自己*/
	//enemy
	for(i=0;i<MAX_ENEMY;i++){
		if(abs(enemies[i].x - plane.x) <= plane.w/2 && abs(enemies[i].y - plane.y) <= plane.h/2){
			if(!enemies[i].hidden){
				al_play_sample(minus_blood_bgm, 1, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &minus_blood_bgm_id);
				plane.hp--;
				game_log("(enemy)minus blood.");
				printf("plane hp=%d\n",plane.hp);
				enemies[i].hidden = true;
				break;
			}
		}
	}
	//tank
	for(i=0;i<MAX_TANK;i++){
		if(abs(tank[i].x - plane.x) <= plane.w/2 && abs(tank[i].y - plane.y) <= plane.h/2){
			if(!tank[i].hidden){
				al_play_sample(minus_blood_bgm, 1, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &minus_blood_bgm_id);
				plane.hp--;
				game_log("(tank)minus blood.");
				printf("plane hp=%d\n",plane.hp);
				tank[i].hidden = true;
				break;
			}
		}
	}
}

void enemy_bullet_touch_you(void)
{
	int i;
	/*敵人子彈碰到自己*/
	for(i=0;i<MAX_ENEMY_BULLET;i++){
		if(abs(enemies_bullet[i].x - plane.x) <= plane.w/2 && abs(enemies_bullet[i].y - plane.y) <= plane.h/2){
			if(!enemies_bullet[i].hidden){
				al_play_sample(minus_blood_bgm, 1, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &minus_blood_bgm_id);
				plane.hp--;
				game_log("(bullet)minus blood.");
				printf("plane hp=%d\n",plane.hp);
				enemies_bullet[i].hidden = true;
				break;
			}
		}
	}
	for(i=0;i<MAX_TANK_BULLET;i++){
		if(abs(tank_bullet[i].x - plane.x) <= tank_bullet[i].w/2 + plane.w/2 && abs(tank_bullet[i].y - plane.y) <= plane.h/2){
			if(!tank_bullet[i].hidden){
				al_play_sample(minus_blood_bgm, 1, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &minus_blood_bgm_id);
				plane.hp--;
				game_log("(bullet)minus blood.");
				printf("plane hp=%d\n",plane.hp);
				tank_bullet[i].hidden = true;
				break;
			}
		}
	}
}

void boss_touch_you(void)
{
	if(abs(plane.x-boss.x) <= plane.w/2 + boss.w/2 && abs(plane.y-boss.y) <= plane.h/2 + boss.h/2){
		if(!boss.hidden){
			al_play_sample(minus_blood_bgm, 1, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &minus_blood_bgm_id);
			plane.hp--;
			game_log("(enemy)minus blood.");
			printf("plane hp=%d\n",plane.hp);
			boss.hidden = true;
		}
	}
}

void shoot_bullet(void)
{
	int i;
	// Shoot if key is down and cool-down is over.
    // 1) Get the time now using 'al_get_time'.
    // 2) If Space key is down in 'key_state' and the time
    //    between now and last shoot is not less that cool
    //    down time.
    // 3) Loop through the bullet array and find one that is hidden.
    //    (This part can be optimized.)
    // 4) The bullet will be found if your array is large enough.
    // 5) Set the last shoot time to now.
    // 6) Set hidden to false (recycle the bullet) and set its x, y to the
    //    front part of your plane.
	/*我方射子彈*/
    double now = al_get_time();
    if (key_state[ALLEGRO_KEY_SPACE] && now - last_shoot_timestamp >= MAX_COOLDOWN){
        for(i=0;i<MAX_BULLET;i++){
            if(bullets[i].hidden){
            	last_shoot_timestamp = now;
                bullets[i].hidden = false;
                bullets[i].x = plane.x;
                bullets[i].y = plane.y-plane.h/2;//plane.y+dong.h/2;
                al_play_sample(shoot_bgm, 1, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &shoot_bgm_id);
                break;
            }
        }
    }
}

void boss_shoot_bullet(void)
{
	int i;
	/*boss射子彈*/
	double now = al_get_time();
	if(now - last_bossshoot_timestamp >= MAX_BOSS_COOLDOWN){
		for(i=0;i<MAX_BOSS_BULLET;i++){
			if(boss_bullet[i].hidden){
				game_log("Boss Shoot");
				last_bossshoot_timestamp = now;
				boss_bullet[i].hidden = false;
				boss_bullet[i].x = boss.x;
				boss_bullet[i].y = boss.y + boss_bullet[i].h/2;
				break;
			}	
		}
	}
}

void boss_bullet_touch_you(void)
{
	int i;
	/*boss子彈碰到自己*/
	for(i=0;i<MAX_BOSS_BULLET;i++){
		if(abs(boss_bullet[i].x - plane.x) <= plane.w/2 && abs(boss_bullet[i].y - plane.y) <= plane.h/2){
			if(!boss_bullet[i].hidden){
				al_play_sample(minus_blood_bgm, 1, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &minus_blood_bgm_id);
				plane.hp--;
				game_log("(bullet)minus blood.");
				printf("plane hp=%d\n",plane.hp);
				boss_bullet[i].hidden = true;
				break;
			}
		}
	}
}
void powerup_shoot_bullet(void)
{
	int i;
	if(!haveplayed){
		al_play_sample(powerup_bgm, 2, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &powerup_bgm_id);
		haveplayed=1;
	}
	/*我方射子彈*/
    double now = al_get_time();
    if (key_state[ALLEGRO_KEY_SPACE] && now - last_shoot_timestamp >= MAX_COOLDOWN){
        for(i=0;i<MAX_POWERUP_BULLET;i+=2){
            if(powerup_bullets[i].hidden && powerup_bullets[i+1].hidden){
            	last_shoot_timestamp = now;
                powerup_bullets[i].hidden = powerup_bullets[i+1].hidden = false;
                powerup_bullets[i].x = plane.x-10 , powerup_bullets[i+1].x = plane.x + 10;
                powerup_bullets[i].y = powerup_bullets[i+1].y = plane.y - plane.h/2;	//plane.y+dong.h/2;
                al_play_sample(shoot_bgm, 1, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &shoot_bgm_id);
                break;
            }
        }
    }
}

void enemy_shoot_bullet(void)
{
	int i,j;
	/*敵方射子彈*/
	double now = al_get_time();
	if(now - last_enemyshoot_timestamp >= MAX_ENEMY_COOLDOWN){
		for(i=0;i<MAX_ENEMY;i++){
			for(j=0;j<MAX_ENEMY_BULLET;j++){
				if(enemies_bullet[j].hidden){
					game_log("Enemy Shoot");
					last_enemyshoot_timestamp = now;
					enemies_bullet[j].hidden = false;
					enemies_bullet[j].x = enemies[i].x;
					enemies_bullet[j].y = enemies[i].y + enemies_bullet[j].h/2;
					break;
				}	
			}			
		}
	}
	if(now - last_tankshoot_timestamp >= MAX_TANK_COOLDOWN){
		for(i=0;i<MAX_TANK;i++){
			for(j=0;j<MAX_TANK_BULLET;j++){
				if(tank_bullet[j].hidden){
					game_log("Tank Shoot");
					last_tankshoot_timestamp = now;
					tank_bullet[j].hidden = false;
					tank_bullet[j].x = tank[i].x;
					tank_bullet[j].y = tank[i].y + tank_bullet[j].h/2;
					break;
				}	
			}			
		}
	}
}

void bullet_hit_enemy(void)
{
	int i,j;
	/*子彈打敵人*/
    for(i=0;i<MAX_BULLET;i++){
    	for(j=0;j<MAX_ENEMY;j++){
    		if(enemies[j].hidden || bullets[i].hidden){
    			continue;
			}
			if( abs(enemies[j].x - bullets[i].x) <= enemies[j].w/2 && abs(enemies[j].y - bullets[i].y) <= enemies[j].h/2){       		
        		bullets[i].hidden = true;
				enemies[j].hp--;
			}
		}
		for(j=0;j<MAX_TANK;j++){
    		if(tank[j].hidden || bullets[i].hidden){
    			continue;
			}
			if( abs(tank[j].x - bullets[i].x) <= tank[j].w/2 && abs(tank[j].y - bullets[i].y) <= tank[j].h/2){
        		bullets[i].hidden = true;
        		tank[j].hp--;
			}
		}
	}
	for(i=0;i<MAX_POWERUP_BULLET;i++){
    	for(j=0;j<MAX_ENEMY;j++){
    		if(enemies[j].hidden || powerup_bullets[i].hidden){
    			continue;
			}
			if( abs(enemies[j].x - powerup_bullets[i].x) <= enemies[j].w/2 && abs(enemies[j].y - powerup_bullets[i].y) <= enemies[j].h/2){       		
        		powerup_bullets[i].hidden = true;
				enemies[j].hp--;
			}
		}
		for(j=0;j<MAX_TANK;j++){
    		if(tank[j].hidden || powerup_bullets[i].hidden){
    			continue;
			}
			if( abs(tank[j].x - powerup_bullets[i].x) <= tank[j].w/2 && abs(tank[j].y - powerup_bullets[i].y) <= tank[j].h/2){
        		powerup_bullets[i].hidden = true;
        		tank[j].hp--;
			}
		}
	}
}

void bullet_hit_boss(void)
{
	int i,j;
	/*子彈打boss*/
    for(i=0;i<MAX_BULLET;i++){
		if(boss.hidden || bullets[i].hidden){
			continue;
		}
		if( abs(boss.x - bullets[i].x) <= boss.w/2 && abs(boss.y - bullets[i].y) <= boss.h/2){       		
    		bullets[i].hidden = true;
			boss.hp--;
			score+=10;
		}
	}
	
	for(i=0;i<MAX_POWERUP_BULLET;i++){
		if(boss.hidden || powerup_bullets[i].hidden){
			continue;
		}
		if( abs(boss.x - powerup_bullets[i].x) <= boss.w/2 && abs(boss.y - powerup_bullets[i].y) <= boss.h/2){       		
    		powerup_bullets[i].hidden = true;
			boss.hp--;
			score+=10;
		}
	}
	if(boss.hp<=0)	win=1;
}

void bullet_hit_bullet(void)
{
	int i,j;
	/*子彈打敵人的子彈*/
	for(i=0;i<MAX_BULLET;i++){
		for(j=0;j<MAX_ENEMY_BULLET;j++){
			if(!enemies_bullet[i].hidden && !bullets[i].hidden){
				if(abs(enemies_bullet[j].x - bullets[i].x) <= bullets[i].w && abs(enemies_bullet[j].y - bullets[i].y) <= bullets[i].h){
					enemies_bullet[j].hidden = true;
					bullets[i].hidden = true;
				}
			}
		}
		for(j=0;j<MAX_TANK_BULLET;j++){
			if(!tank_bullet[i].hidden && !bullets[i].hidden){
				if(abs(tank_bullet[j].x - bullets[i].x) <= bullets[i].w && abs(tank_bullet[j].y - bullets[i].y) <= bullets[i].h){
					tank_bullet[j].hidden = true;
					bullets[i].hidden = true;
				}
			}
		}
	}
	for(i=0;i<MAX_POWERUP_BULLET;i++){
		for(j=0;j<MAX_ENEMY_BULLET;j++){
			if(!enemies_bullet[i].hidden && !powerup_bullets[i].hidden){
				if(abs(enemies_bullet[j].x - powerup_bullets[i].x) <= powerup_bullets[i].w && abs(enemies_bullet[j].y - powerup_bullets[i].y) <= powerup_bullets[i].h){
					enemies_bullet[j].hidden = true;
					powerup_bullets[i].hidden = true;
				}
			}
			
		}
		for(j=0;j<MAX_TANK_BULLET;j++){
			if(!tank_bullet[i].hidden && !powerup_bullets[i].hidden){
				if(abs(tank_bullet[j].x - powerup_bullets[i].x) <= powerup_bullets[i].w && abs(tank_bullet[j].y - powerup_bullets[i].y) <= powerup_bullets[i].h){
					tank_bullet[j].hidden = true;
					powerup_bullets[i].hidden = true;
				}
			}
		}
	}
}

void bullet_hit_boss_bullet(void)
{
	int i,j;
	/*子彈打boss的子彈*/
	for(i=0;i<MAX_BULLET;i++){
		for(j=0;j<MAX_BOSS_BULLET;j++){
			if(!boss_bullet[j].hidden && !bullets[i].hidden){
				if(abs(boss_bullet[j].x - bullets[i].x) <= bullets[i].w && abs(boss_bullet[j].y - bullets[i].y) <= bullets[i].h){
					boss_bullet[j].hidden = true;
					bullets[i].hidden = true;
				}
			}
		}
	}
	for(i=0;i<MAX_POWERUP_BULLET;i++){
		for(j=0;j<MAX_BOSS_BULLET;j++){
			if(!boss_bullet[j].hidden && !powerup_bullets[i].hidden){
				if(abs(boss_bullet[j].x - powerup_bullets[i].x) <= powerup_bullets[i].w && abs(boss_bullet[j].y - powerup_bullets[i].y) <= powerup_bullets[i].h){
					boss_bullet[j].hidden = true;
					powerup_bullets[i].hidden = true;
				}
			}
		}
	}
}

int main(int argc, char** argv) {
    // Set random seed for better random outcome.
    srand(time(NULL));
    allegro5_init();
    game_log("Allegro5 initialized");
    game_log("Game begin");
    // Initialize game variables.
    game_init();
    game_log("Game initialized");
	// Draw the first frame.
    game_draw();
    game_log("Game start event loop");
    // This call blocks until the game is finished.
    game_start_event_loop();
    game_log("Game end");
    game_destroy();
    return 0;
}

void allegro5_init(void){
    if (!al_init())
        game_abort("failed to initialize allegro");
    if (!al_init_primitives_addon())
        game_abort("failed to initialize primitives add-on");
    if (!al_init_font_addon())
        game_abort("failed to initialize font add-on");
    if (!al_init_ttf_addon())
        game_abort("failed to initialize ttf add-on");
    if (!al_init_image_addon())
        game_abort("failed to initialize image add-on");
    if (!al_install_audio())
        game_abort("failed to initialize audio add-on");
    if (!al_init_acodec_addon())
        game_abort("failed to initialize audio codec add-on");
    if (!al_reserve_samples(RESERVE_SAMPLES))
        game_abort("failed to reserve samples");
    if (!al_install_keyboard())
        game_abort("failed to install keyboard");
    if (!al_install_mouse())
        game_abort("failed to install mouse");

    // Setup game display.
    game_display = al_create_display(SCREEN_W, SCREEN_H);
    if (!game_display)
        game_abort("failed to create display");
    al_set_window_title(game_display, "I2P(I)_2020 Final Project <109062318>");

    // Setup update timer.
    game_update_timer = al_create_timer(1.0f / FPS);
    if (!game_update_timer)
        game_abort("failed to create timer");

    // Setup event queue.
    game_event_queue = al_create_event_queue();
    if (!game_event_queue)
        game_abort("failed to create event queue");

    // Malloc mouse buttons state according to button counts.
    const unsigned m_buttons = al_get_mouse_num_buttons();
    game_log("There are total %u supported mouse buttons", m_buttons);
    // mouse_state[0] will not be used.
    mouse_state = malloc((m_buttons + 1) * sizeof(bool));
    memset(mouse_state, false, (m_buttons + 1) * sizeof(bool));

    // Register display, timer, keyboard, mouse events to the event queue.
    al_register_event_source(game_event_queue, al_get_display_event_source(game_display));
    al_register_event_source(game_event_queue, al_get_timer_event_source(game_update_timer));
    al_register_event_source(game_event_queue, al_get_keyboard_event_source());
    al_register_event_source(game_event_queue, al_get_mouse_event_source());

    // Start the timer to update and draw the game.
    al_start_timer(game_update_timer);
}

void game_init(void){
/*--------------------------------------fonts------------------------------------------*/
    font_pirulen_32 = al_load_font("pirulen.ttf", 32, 0);
    if (!font_pirulen_32)
        game_abort("failed to load font: pirulen.ttf with size 32");

    font_pirulen_24 = al_load_font("pirulen.ttf", 24, 0);
    if (!font_pirulen_24)
        game_abort("failed to load font: pirulen.ttf with size 24");
	
	font_pirulen_16 = al_load_font("pirulen.ttf",16,0);
	if(!font_pirulen_16){
		game_abort("failed to load font: pirulen.ttf with size 16");
	}
/*--------------------------------------menu,settings resources------------------------------------------*/
    main_img_background = load_bitmap_resized("main-bg.jpg", SCREEN_W, SCREEN_H);
	win_img_background =load_bitmap_resized("win.jpg", SCREEN_W, SCREEN_H);
	boss_img_background = load_bitmap_resized("boss_background.jpg", SCREEN_W, SCREEN_H);
	
    main_bgm = al_load_sample("S31-Night Prowler.ogg");
    if (!main_bgm)
        game_abort("failed to load audio: S31-Night Prowler.ogg");
        
    img_settings = al_load_bitmap("settings.png");
    if (!img_settings)
        game_abort("failed to load image: settings.png");
        
    img_settings2 = al_load_bitmap("settings2.png");
    if (!img_settings2)
        game_abort("failed to load image: settings2.png");
	
	img_backbutton = al_load_bitmap("back.png");
	if(!img_backbutton)
		game_abort("failed to load image: backbutton.png");
		
	img_backbuttonlighter=al_load_bitmap("back-lighter.png");
	if(!img_backbuttonlighter)
		game_abort("failed to load image: back-lighter.png");
	
	img_information=al_load_bitmap("information.png");
	if(!img_information)
		game_abort("failed to load image: information.png");
	
	img_information_lighter=al_load_bitmap("information-lighter.png");
	if(!img_information_lighter)
		game_abort("failed to load image: information-lighter.png");
/*--------------------------------------start scene resources------------------------------------------*/
    start_img_background = load_bitmap_resized("start-bg.jpg", SCREEN_W, SCREEN_H);
	
	img_addhp=al_load_bitmap("addhp.png");
	if(!img_addhp)
		game_abort("addhp.png");
	
	img_minushp=al_load_bitmap("poison.png");
	if(!img_minushp)
		game_abort("failed to load image: poison.png");
	
    start_img_plane = al_load_bitmap("plane.png");
    if (!start_img_plane)
        game_abort("failed to load image: plane.png");

    start_img_enemy = al_load_bitmap("smallfighter0006.png");
    if (!start_img_enemy)
        game_abort("failed to load image: smallfighter0006.png");
/*--------------------------------------sound effects------------------------------------------*/
    start_bgm = al_load_sample("mythica.ogg");
    if (!start_bgm)
        game_abort("failed to load audio: mythica.ogg");
	
	shoot_bgm = al_load_sample("heat-vision.wav");
	if(!shoot_bgm)
		game_abort("failed to load audio: heat-vision.wav");
	
	level_completed_bgm=al_load_sample("level-completed.wav");
	if(!level_completed_bgm)
		game_abort("failed to load audio: level-completed.wav");
	
	losing_bgm=al_load_sample("losing.wav");
	if(!losing_bgm)
		game_abort("failed to load audio: losing.wav");
	
	minus_blood_bgm=al_load_sample("minus-blood.wav");
	if(!minus_blood_bgm)
		game_abort("failed to load audio: minus-blood.wav");
	
	powerup_bgm=al_load_sample("powerup.wav");
	if(!powerup_bgm)
		game_abort("failed to load audio: powerup.wav");
	
	enemy_dead_bgm=al_load_sample("pop.wav");
	if(!enemy_dead_bgm)
		game_abort("failed to load audio: pop.wav");
	
	eataddhp_bgm=al_load_sample("eataddhp.wav");
	if(!eataddhp_bgm)
		game_abort("failed to load audio: eataddhp.wav");
	
	boss_bgm=al_load_sample("boss_alert.wav");
	if(!boss_bgm)
		game_abort("failed to load audio: boss_alert.wav");
/*--------------------------------------images------------------------------------------*/
	img_rocket1=al_load_bitmap("rocket-1.png");
	if(!img_rocket1)
		game_abort("failed to load image: rocket-1.png");
		
	img_rocket2=al_load_bitmap("rocket-2.png");
	if(!img_rocket2)
		game_abort("failed to load image: rocket-2.png");
		
	img_tank=al_load_bitmap("tank-1.png");
	if(!img_tank)
		game_abort("failed to load image: tank-1.png");
		
    img_bullet = al_load_bitmap("image12.png");
    if(!img_bullet)
        game_abort("failed to load image: image12.png");
	
	img_boss=al_load_bitmap("boss.png");
	if(!img_boss)
		game_abort("failed to load image: boss.png");
	
	img_boss_bullet=al_load_bitmap("boss_bullet.png");
	if(!img_boss_bullet)
		game_abort("failed to load image: boss_bullet.png");
		
	/*img_dongyong = al_load_bitmap("dong.png");
	if(!img_dongyong)
		game_abort("failed to load image: dong.png");*/
	
    //Change to first scene.
    game_change_scene(SCENE_MENU);
}

void game_start_event_loop(void) {
    bool done = false;
    ALLEGRO_EVENT event;
    int redraws = 0;
    while (!done){
        al_wait_for_event(game_event_queue, &event);
        if (event.type == ALLEGRO_EVENT_DISPLAY_CLOSE) {
            // Event for clicking the window close button.
            game_log("Window close button clicked");
            done = true;
        } else if (event.type == ALLEGRO_EVENT_TIMER) {
            // Event for redrawing the display.
            if (event.timer.source == game_update_timer)
                // The redraw timer has ticked.
                redraws++;
        } else if (event.type == ALLEGRO_EVENT_KEY_DOWN) {
            // Event for keyboard key down.
            game_log("Key with keycode %d down", event.keyboard.keycode);
            key_state[event.keyboard.keycode] = true;
            on_key_down(event.keyboard.keycode);
        } else if (event.type == ALLEGRO_EVENT_KEY_UP) {
            // Event for keyboard key up.
            game_log("Key with keycode %d up", event.keyboard.keycode);
            key_state[event.keyboard.keycode] = false;
        } else if (event.type == ALLEGRO_EVENT_MOUSE_BUTTON_DOWN) {
            // Event for mouse key down.
            game_log("Mouse button %d down at (%d, %d)", event.mouse.button, event.mouse.x, event.mouse.y);
            mouse_state[event.mouse.button] = true;
            on_mouse_down(event.mouse.button, event.mouse.x, event.mouse.y);
        } else if (event.type == ALLEGRO_EVENT_MOUSE_BUTTON_UP) {
            // Event for mouse key up.
            game_log("Mouse button %d up at (%d, %d)", event.mouse.button, event.mouse.x, event.mouse.y);
            mouse_state[event.mouse.button] = false;
        } else if (event.type == ALLEGRO_EVENT_MOUSE_AXES) {
            if (event.mouse.dx != 0 || event.mouse.dy != 0) {
                // Event for mouse move.
                // game_log("Mouse move to (%d, %d)", event.mouse.x, event.mouse.y);
                mouse_x = event.mouse.x;
                mouse_y = event.mouse.y;
            } else if (event.mouse.dz != 0) {
                // Event for mouse scroll.
                game_log("Mouse scroll at (%d, %d) with delta %d", event.mouse.x, event.mouse.y, event.mouse.dz);
            }
        }

        // Redraw
        if(redraws > 0 && al_is_event_queue_empty(game_event_queue)){
            // if (redraws > 1)
            //     game_log("%d frame(s) dropped", redraws - 1);
            // Update and draw the next frame.
            game_update();
            game_draw();
            redraws = 0;
        }
    }
}

void game_update(void){
	int i,j;
    if(active_scene == SCENE_START || active_scene == SCENE_BOSS){
    	draw_addhp();
        
		draw_minushp();
		
		draw_plane();
    	       
        draw_bullet();                
        
		draw_enemy();
		
		draw_enemy_bullet();
		
		if(active_scene == SCENE_BOSS){
			draw_boss();
			draw_boss_bullet();
			boss_shoot_bullet();
			boss_touch_you();
			boss_bullet_touch_you();
			bullet_hit_boss();
			bullet_hit_boss_bullet();
		}
		
		addhp_touch_you();
		
		minushp_touch_you();
		
		enemy_touch_you();
		
		enemy_shoot_bullet();
		
		enemy_bullet_touch_you();
		
		bullet_hit_enemy();
		
		bullet_hit_bullet();
		
		if(beat_count >= POWERUP_COUNT){
			powerup_shoot_bullet();
		}else{
			shoot_bullet();
		}
			
		if(plane.hp<=0){
			game_change_scene(SCENE_YOUDEAD);
		}
		
		if(win){
			game_change_scene(SCENE_YOUWIN);
			
		}else if(active_scene == SCENE_START && BOSS_POINT <= score){
			game_change_scene(SCENE_BOSS);
			
		}
    }
}

void game_draw(void){
    if(active_scene == SCENE_MENU){
    	
        al_draw_bitmap(main_img_background, 0, 0, 0);
        al_draw_text(font_pirulen_32, al_map_rgb(255, 255, 255), SCREEN_W / 2, 30, ALLEGRO_ALIGN_CENTER, "Space Shooter");
        al_draw_text(font_pirulen_24, al_map_rgb(255, 255, 255), 20, SCREEN_H - 50, 0, "Press enter key to start");
        
        //settings 38*38
        if(pnt_in_rect(mouse_x, mouse_y, SCREEN_W - 48, 10, 38, 38))
            al_draw_bitmap(img_settings2, SCREEN_W - 48, 10, 0);
        else
            al_draw_bitmap(img_settings, SCREEN_W - 48, 10, 0);
    } else if (active_scene == SCENE_START) {
        int i;
        al_draw_bitmap(start_img_background, 0, 0, 0);
        al_draw_textf(font_pirulen_24, al_map_rgb(200, 0, 0),   0, 10, ALLEGRO_ALIGN_LEFT, "Hp: %d", plane.hp);
        al_draw_textf(font_pirulen_24, al_map_rgb(0, 200, 0),   0, 70, ALLEGRO_ALIGN_LEFT, "Score: %d", score);
        al_draw_textf(font_pirulen_24, al_map_rgb(0, 0, 200), SCREEN_W/2 - 100,  0, 0,  "%d TO BOSS", BOSS_POINT-score);
        
        
        draw_movable_object(plane);
        draw_movable_object(addhp);
        for(i=0;i<MAX_POISON;i++){
			draw_movable_object(minushp[i]);
		}
        
        for(i=0;i<MAX_BULLET;i++)
            draw_movable_object(bullets[i]);
        for(i=0;i<MAX_POWERUP_BULLET;i++)
            draw_movable_object(powerup_bullets[i]);
            
        for(i=0;i<MAX_ENEMY;i++)
        	draw_movable_object(enemies[i]);
        for(i=0;i<MAX_ENEMY_BULLET;i++)
        	draw_movable_object(enemies_bullet[i]);
        
        for(i=0;i<MAX_TANK;i++)
        	draw_movable_object(tank[i]);
		for(i=0;i<MAX_TANK_BULLET;i++)
			draw_movable_object(tank_bullet[i]);
			
    }else if(active_scene == SCENE_SETTINGS){
        al_clear_to_color(al_map_rgb(0, 0, 0));
        
        //back button 170*170
        if(pnt_in_rect(mouse_x,mouse_y,SCREEN_W-200,SCREEN_H-200,150,150)){
        	al_draw_bitmap(img_backbuttonlighter,SCREEN_W-200,SCREEN_H-200,0);
		}else{
			al_draw_bitmap(img_backbutton,SCREEN_W-200,SCREEN_H-200,0);	
		}
		
        //information button 188*151
        if(pnt_in_rect(mouse_x,mouse_y,40,SCREEN_H-200,160,145)){
        	al_draw_bitmap(img_information_lighter,40,SCREEN_H-200,0);
		}else{
			al_draw_bitmap(img_information,40,SCREEN_H-200,0);
		}
		
    }else if(active_scene==SCENE_YOUDEAD){
    	al_clear_to_color( al_map_rgb(0,0,0) );
    	
    	al_draw_text (font_pirulen_32, al_map_rgb(255, 255, 255), SCREEN_W / 2, 30, ALLEGRO_ALIGN_CENTER, "You dead !");
    	al_draw_textf(font_pirulen_32, al_map_rgb(255, 255, 255), SCREEN_W / 2, 70, ALLEGRO_ALIGN_CENTER, "Score: %d", score);
        
        //backbutton
    	if(pnt_in_rect(mouse_x,mouse_y,SCREEN_W-170,SCREEN_H-170,145,145)){
        	al_draw_bitmap(img_backbuttonlighter,SCREEN_W-170,SCREEN_H-170,0);
		}else{
			al_draw_bitmap(img_backbutton,SCREEN_W-170,SCREEN_H-170,0);	
		}
		
	}else if(active_scene==SCENE_INFOR){
		al_clear_to_color( al_map_rgb(0,0,0) );
		
		al_draw_text(font_pirulen_24, al_map_rgb(255, 255, 255), SCREEN_W / 2,  30, ALLEGRO_ALIGN_CENTER, "Instruction: ");
		al_draw_textf(font_pirulen_24, al_map_rgb(255, 255, 255), SCREEN_W / 2,  80, ALLEGRO_ALIGN_CENTER, "enemy HP = 2 , tank HP = 1 , your HP = %d",LIFE);
		al_draw_text(font_pirulen_24, al_map_rgb(255, 255, 255), SCREEN_W / 2, 130, ALLEGRO_ALIGN_CENTER, "try your best to win the game !");
		al_draw_text(font_pirulen_24, al_map_rgb(255, 255, 255), SCREEN_W / 2, 180, ALLEGRO_ALIGN_CENTER, "enjoy : )");
		al_draw_text(font_pirulen_24, al_map_rgb(255, 255, 255), SCREEN_W / 2, 300, ALLEGRO_ALIGN_CENTER, "[ press backspace to leave ]");
		
	}else if(active_scene==SCENE_YOUWIN){
		al_draw_bitmap(win_img_background, 0, 0, 0);
		
		al_draw_text (font_pirulen_32, al_map_rgb(0, 0, 0), SCREEN_W / 2, 30, ALLEGRO_ALIGN_CENTER, "You WIN !");
    	al_draw_textf(font_pirulen_32, al_map_rgb(0, 0, 0), SCREEN_W / 2, 70, ALLEGRO_ALIGN_CENTER, "Score: %d", score);
        
        //back button 170*170
        if(pnt_in_rect(mouse_x,mouse_y,SCREEN_W-170,SCREEN_H-170,145,145)){
        	al_draw_bitmap(img_backbuttonlighter,SCREEN_W-170,SCREEN_H-170,0);
		}else{
			al_draw_bitmap(img_backbutton,SCREEN_W-170,SCREEN_H-170,0);	
		}
	}else if(active_scene==SCENE_BOSS){
		int i;
		al_draw_bitmap(boss_img_background, 0, 0, 0);
		
		al_draw_textf(font_pirulen_24, al_map_rgb(200, 0, 0),   0, 10, ALLEGRO_ALIGN_LEFT, "Hp: %d", plane.hp);
        al_draw_textf(font_pirulen_24, al_map_rgb(0, 200, 0),   0, 70, ALLEGRO_ALIGN_LEFT, "Score: %d", score);
		al_draw_textf(font_pirulen_24, al_map_rgb(200, 0, 0),   SCREEN_W/2, 10, ALLEGRO_ALIGN_CENTER, "Boss Hp: %d", boss.hp);
        
		draw_movable_object(plane);
        draw_movable_object(addhp);
        draw_movable_object(boss);
        for(i=0;i<MAX_POISON;i++){
			draw_movable_object(minushp[i]);
		}
		
		for(i=0;i<MAX_BULLET;i++)
            draw_movable_object(bullets[i]);
        for(i=0;i<MAX_POWERUP_BULLET;i++)
            draw_movable_object(powerup_bullets[i]);
            
        for(i=0;i<MAX_ENEMY;i++)
        	draw_movable_object(enemies[i]);
        for(i=0;i<MAX_ENEMY_BULLET;i++)
        	draw_movable_object(enemies_bullet[i]);
        
        for(i=0;i<MAX_TANK;i++)
        	draw_movable_object(tank[i]);
		for(i=0;i<MAX_TANK_BULLET;i++)
			draw_movable_object(tank_bullet[i]);
			
		for(i=0;i<MAX_BOSS_BULLET;i++)
			draw_movable_object(boss_bullet[i]);
	}
    al_flip_display();
}



void game_change_scene(int next_scene){
    game_log("Change scene from %d to %d", active_scene, next_scene);
    //Destroy resources initialized when creating scene.
    if(active_scene == SCENE_MENU){
        al_stop_sample(&main_bgm_id);
        game_log("stop audio (bgm)");
    }else if(active_scene == SCENE_START){
        al_stop_sample(&start_bgm_id);
        game_log("stop audio (bgm)");
    }else if(active_scene==SCENE_BOSS){
    	al_stop_sample(&boss_bgm_id);
        game_log("stop audio (bgm)");
	}
    active_scene = next_scene;
    //Allocate resources before entering scene.
    if(active_scene == SCENE_MENU){
    	haveplayed=0;
        if(!al_play_sample(main_bgm, 1, 0.0, 1.0, ALLEGRO_PLAYMODE_LOOP, &main_bgm_id))
            game_abort("failed to play audio (bgm)");
    } else if (active_scene == SCENE_START) {	//初始化
        int i;
        haveplayed=0;
        beat_count=0;
		score=0;
		win=0;
		
		//addhp
		addhp.img = img_addhp;
		addhp.w = al_get_bitmap_width(img_addhp);
		addhp.h = al_get_bitmap_height(img_addhp);
		addhp.hidden = true;
		addhp.x = (float)rand() / RAND_MAX * (SCREEN_W - addhp.w);
		addhp.y = 100;
		addhp.vx = 2 * ( (float)rand() / RAND_MAX )-1;
		addhp.vy = 2;
		
		//minushp
		for(i=0;i<MAX_POISON;i++){
			minushp[i].img = img_minushp;
			minushp[i].w = al_get_bitmap_width(img_minushp);
			minushp[i].h = al_get_bitmap_height(img_minushp);
			minushp[i].hidden = true;
			minushp[i].x = (float)rand() / RAND_MAX * (SCREEN_W - minushp[i].w);
			minushp[i].y = 100;
			minushp[i].vx = 2*( (float)rand() / RAND_MAX )-1;
			minushp[i].vy = 5;
		}
		
        // plane
        plane.img = start_img_plane;
        plane.x = 400;
        plane.y = 500;
        plane.w = al_get_bitmap_width(plane.img);
        plane.h = al_get_bitmap_height(plane.img);
        plane.hp = LIFE;
        
        // enemy
        for(i=0;i<MAX_ENEMY;i++){
            enemies[i].img = start_img_enemy;
            enemies[i].w = al_get_bitmap_width(start_img_enemy);
            enemies[i].h = al_get_bitmap_height(start_img_enemy);
            enemies[i].x = enemies[i].w / 2 + (float)rand() / RAND_MAX * (SCREEN_W - enemies[i].w);
            enemies[i].y = 80;
            enemies[i].vx = 0.5;
            enemies[i].vy = 1.5;
            enemies[i].hp = 2;
        }
        
        // enemy bullet
        for(i=0;i<MAX_ENEMY_BULLET;i++){
        	enemies_bullet[i].img = img_rocket1;
        	enemies_bullet[i].w = al_get_bitmap_width(img_rocket1);
        	enemies_bullet[i].h = al_get_bitmap_height(img_rocket1);
        	enemies_bullet[i].vx = 0;
        	enemies_bullet[i].vy = 3;
		}
		
		//bullet
        for(i=0;i<MAX_BULLET;i++){
            bullets[i].w = al_get_bitmap_width(img_bullet);
            bullets[i].h = al_get_bitmap_height(img_bullet);
            bullets[i].img = img_bullet;//img_dongyong;
            bullets[i].vx = 0;
            bullets[i].vy = -5;
            bullets[i].hidden = true;
        }
        for(i=0;i<MAX_POWERUP_BULLET;i++){
            powerup_bullets[i].w = al_get_bitmap_width(img_bullet);
            powerup_bullets[i].h = al_get_bitmap_height(img_bullet);
            powerup_bullets[i].img = img_bullet;//img_dongyong;
            powerup_bullets[i].vx = 0;
            powerup_bullets[i].vy = -5;
            powerup_bullets[i].hidden = true;
        }
        
        //tank
        for(i=0;i<MAX_TANK;i++){
        	tank[i].img = img_tank;
			tank[i].w = al_get_bitmap_width(tank[i].img);
	    	tank[i].h = al_get_bitmap_height(tank[i].img);
			tank[i].hp = 1;
			tank[i].x = (float)rand() / RAND_MAX * (SCREEN_W - tank[i].w);
			tank[i].y = 80;
			tank[i].vx = 2*( (float)rand() / RAND_MAX )-1;
			tank[i].vy = 1.5;
		}
        for(i=0;i<MAX_TANK_BULLET;i++){
        	tank_bullet[i].img = img_rocket2;
        	tank_bullet[i].w = al_get_bitmap_width(img_rocket2);
        	tank_bullet[i].h = al_get_bitmap_height(img_rocket2);
        	tank_bullet[i].vx = 0;
        	tank_bullet[i].vy = 3;
		}
		
        if (!al_play_sample(start_bgm, 1, 0.0, 1.0, ALLEGRO_PLAYMODE_LOOP, &start_bgm_id))
            game_abort("failed to play audio (bgm)");
    }else if(active_scene==SCENE_YOUDEAD){
    	
    	al_play_sample(losing_bgm, 1, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &losing_bgm_id);
    	
	}else if(active_scene==SCENE_YOUWIN){
		
		al_play_sample(level_completed_bgm, 1, 0.0, 1.0, ALLEGRO_PLAYMODE_ONCE, &level_completed_bgm_id);
		
	}else if(active_scene==SCENE_BOSS){
		int i;
		al_play_sample(boss_bgm, 1, 0.0, 1.0, ALLEGRO_PLAYMODE_LOOP, &boss_bgm_id);
		
		//addhp
		addhp.img = img_addhp;
		addhp.w = al_get_bitmap_width(img_addhp);
		addhp.h = al_get_bitmap_height(img_addhp);
		addhp.vx = 2*( (float)rand() / RAND_MAX )-1;
		addhp.vy = 2;
		
		//minushp
		for(i=0;i<MAX_POISON;i++){
			minushp[i].img = img_minushp;
			minushp[i].w = al_get_bitmap_width(img_minushp);
			minushp[i].h = al_get_bitmap_height(img_minushp);
			minushp[i].vx = 2*( (float)rand() / RAND_MAX )-1;
			minushp[i].vy = 5;
		}
		
        // plane
        plane.img = start_img_plane;
        plane.w = al_get_bitmap_width(plane.img);
        plane.h = al_get_bitmap_height(plane.img);
        
        // enemy
        for(i=0;i<MAX_ENEMY;i++){
            enemies[i].img = start_img_enemy;
            enemies[i].w = al_get_bitmap_width(start_img_enemy);
            enemies[i].h = al_get_bitmap_height(start_img_enemy);
            enemies[i].vx = 0.5;
            enemies[i].vy = 1.5;
            enemies[i].hp = 2;
        }
        
        // enemy bullet
        for(i=0;i<MAX_ENEMY_BULLET;i++){
        	enemies_bullet[i].img = img_rocket1;
        	enemies_bullet[i].w = al_get_bitmap_width(img_rocket1);
        	enemies_bullet[i].h = al_get_bitmap_height(img_rocket1);
        	enemies_bullet[i].vx = 0;
        	enemies_bullet[i].vy = 3;
		}
		
        //bullet
        for(i=0;i<MAX_BULLET;i++){
            bullets[i].w = al_get_bitmap_width(img_bullet);
            bullets[i].h = al_get_bitmap_height(img_bullet);
            bullets[i].img = img_bullet;	//img_dongyong;
            bullets[i].vx = 0;
            bullets[i].vy = -5;
        }
        for(i=0;i<MAX_POWERUP_BULLET;i++){
            powerup_bullets[i].w = al_get_bitmap_width(img_bullet);
            powerup_bullets[i].h = al_get_bitmap_height(img_bullet);
            powerup_bullets[i].img = img_bullet;	//img_dongyong;
            powerup_bullets[i].vx = 0;
            powerup_bullets[i].vy = -5;
        }
        
        //tank
        for(i=0;i<MAX_TANK;i++){
        	tank[i].img = img_tank;
			tank[i].w = al_get_bitmap_width(tank[i].img);
	    	tank[i].h = al_get_bitmap_height(tank[i].img);
			tank[i].hp = 1;
			tank[i].vx = 2*( (float)rand() / RAND_MAX )-1;
			tank[i].vy = 1.5;
		}
        for(i=0;i<MAX_TANK_BULLET;i++){
        	tank_bullet[i].img = img_rocket2;
        	tank_bullet[i].w = al_get_bitmap_width(img_rocket2);
        	tank_bullet[i].h = al_get_bitmap_height(img_rocket2);
        	tank_bullet[i].vx = 0;
        	tank_bullet[i].vy = 3;
		}
		
		//boss
		boss.img=img_boss;
		boss.hp=BOSS_LIFE;
		boss.w=al_get_bitmap_width(img_boss);;
		boss.h=al_get_bitmap_height(img_boss);
		boss.x=SCREEN_W/2;	//(float)rand() / RAND_MAX * (SCREEN_W - boss.w);
		boss.y=180;
		boss.vx=BOSS_SPEED;
		
		//boss bullet
		for(i=0;i<MAX_BOSS_BULLET;i++){
        	boss_bullet[i].img = img_boss_bullet;
        	boss_bullet[i].w = al_get_bitmap_width(img_boss_bullet);
        	boss_bullet[i].h = al_get_bitmap_height(img_boss_bullet);
        	boss_bullet[i].vx = 0;
        	boss_bullet[i].vy = BOSS_BULLET_SPEED;
        	boss_bullet[i].hidden=true;
		}
	}
}

void on_key_down(int keycode){
    if(active_scene == SCENE_MENU){
    	
        if(keycode == ALLEGRO_KEY_ENTER)
            game_change_scene(SCENE_START);
            
    }else if(active_scene == SCENE_INFOR){
    	
        if(keycode == ALLEGRO_KEY_BACKSPACE)
            game_change_scene(SCENE_SETTINGS);
            
    }
}

void on_mouse_down(int btn, int x, int y){
    if(active_scene == SCENE_MENU){
        if(btn == 1){
            if(pnt_in_rect(x, y, SCREEN_W - 48, 10, 38, 38))
                game_change_scene(SCENE_SETTINGS);
        }
    }else if(active_scene==SCENE_SETTINGS){
    	if(btn==1){
    		if(pnt_in_rect(mouse_x,mouse_y,SCREEN_W-200,SCREEN_H-200,150,150)){
    			game_change_scene(SCENE_MENU);
			}
			if(pnt_in_rect(mouse_x,mouse_y,40,SCREEN_H-200,160,145)){
    			game_change_scene(SCENE_INFOR);
			}
		}
	}else if(active_scene==SCENE_YOUDEAD){
		if(btn==1){
			if(pnt_in_rect(mouse_x,mouse_y,SCREEN_W-170,SCREEN_H-170,145,145)){
				game_change_scene(SCENE_MENU);
			}
		}
	}else if(active_scene==SCENE_YOUWIN){
		if(btn==1){
			if(pnt_in_rect(mouse_x,mouse_y,SCREEN_W-170,SCREEN_H-170,145,145)){
				game_change_scene(SCENE_MENU);
			}
		}
	}
}

void draw_movable_object(MovableObject obj){
    if (obj.hidden)
        return;
    al_draw_bitmap(obj.img, round(obj.x - obj.w / 2), round(obj.y - obj.h / 2), 0);
}

ALLEGRO_BITMAP *load_bitmap_resized(const char *filename, int w, int h) {
    ALLEGRO_BITMAP* loaded_bmp = al_load_bitmap(filename);
    if (!loaded_bmp)
        game_abort("failed to load image: %s", filename);
    ALLEGRO_BITMAP *resized_bmp = al_create_bitmap(w, h);
    ALLEGRO_BITMAP *prev_target = al_get_target_bitmap();

    if (!resized_bmp)
        game_abort("failed to create bitmap when creating resized image: %s", filename);
    al_set_target_bitmap(resized_bmp);
    al_draw_scaled_bitmap(loaded_bmp, 0, 0,
        al_get_bitmap_width(loaded_bmp),
        al_get_bitmap_height(loaded_bmp),
        0, 0, w, h, 0);
    al_set_target_bitmap(prev_target);
    al_destroy_bitmap(loaded_bmp);

    game_log("resized image: %s", filename);

    return resized_bmp;
}

bool pnt_in_rect(int px, int py, int x, int y, int w, int h){
    if(x<=px && px<=x+w && y<=py && py<=y+h)
		return true;
	else
		return false;
}

void game_destroy(void) {
	/*fonts*/
    al_destroy_font(font_pirulen_32);
    al_destroy_font(font_pirulen_24);
	al_destroy_font(font_pirulen_16);
	
    /*Menu Scene resources*/
    al_destroy_bitmap(main_img_background);
    al_destroy_sample(main_bgm);
    
    /*Settings images*/
    al_destroy_bitmap(img_settings);
    al_destroy_bitmap(img_settings2);
	al_destroy_bitmap(img_backbutton);
	al_destroy_bitmap(img_backbuttonlighter);
	al_destroy_bitmap(img_information);
	al_destroy_bitmap(img_information_lighter);
	
    /*Start Scene resources*/
    al_destroy_bitmap(img_addhp);
    al_destroy_bitmap(img_minushp);
    al_destroy_bitmap(start_img_background);
    al_destroy_bitmap(start_img_plane);
    al_destroy_bitmap(start_img_enemy);
    al_destroy_bitmap(img_rocket1);
    al_destroy_bitmap(img_rocket2);
    al_destroy_bitmap(img_tank);
    al_destroy_bitmap(img_bullet);
    al_destroy_bitmap(img_boss);
    al_destroy_bitmap(img_boss_bullet);
    al_destroy_bitmap(boss_img_background);
    
    /*Win Scene resources*/
    al_destroy_bitmap(win_img_background);
    
    /*Sound effects*/
    al_destroy_sample(start_bgm);
    al_destroy_sample(shoot_bgm);
    al_destroy_sample(level_completed_bgm);
    al_destroy_sample(powerup_bgm);
    al_destroy_sample(losing_bgm);
    al_destroy_sample(minus_blood_bgm);
    al_destroy_sample(enemy_dead_bgm);
    al_destroy_sample(eataddhp_bgm);
    al_destroy_sample(boss_bgm);
    
	/*Others*/
    al_destroy_timer(game_update_timer);
    al_destroy_event_queue(game_event_queue);
    al_destroy_display(game_display);
    free(mouse_state);
}

// +=================================================================+
// | Code below is for debugging purpose, it's fine to remove it.    |
// | Deleting the code below and removing all calls to the functions |
// | doesn't affect the game.                                        |
// +=================================================================+

void game_abort(const char* format, ...) {
    va_list arg;
    va_start(arg, format);
    game_vlog(format, arg);
    va_end(arg);
    fprintf(stderr, "error occured, exiting after 2 secs");
    // Wait 2 secs before exiting.
    al_rest(2);
    // Force exit program.
    exit(1);
}

void game_log(const char* format, ...) {
#ifdef LOG_ENABLED
    va_list arg;
    va_start(arg, format);
    game_vlog(format, arg);
    va_end(arg);
#endif
}

void game_vlog(const char* format, va_list arg) {
#ifdef LOG_ENABLED
    static bool clear_file = true;
    vprintf(format, arg);
    printf("\n");
    // Write log to file for later debugging.
    FILE* pFile = fopen("log.txt", clear_file ? "w" : "a");
    if (pFile) {
        vfprintf(pFile, format, arg);
        fprintf(pFile, "\n");
        fclose(pFile);
    }
    clear_file = false;
#endif
}
