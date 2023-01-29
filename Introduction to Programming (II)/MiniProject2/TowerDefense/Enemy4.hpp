#ifndef ENEMY4_HPP
#define ENEMY4_HPP
#include "Enemy.hpp"

class Enemy4 : public Enemy {
public:
	Enemy4(int x, int y);
	void CreateBullet() override;
};
#endif // ENEMY4_HPP