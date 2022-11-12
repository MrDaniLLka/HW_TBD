package main

import (
	"fmt"
	"math/rand"
)

var Burrow = 10
var Health = 100
var Respect = 20
var Weight = 30

func main() {
	for {
		params()
		fmt.Println("Сейчас день, что будем делать?\n1) Копать\n2) Кушть\n3) Сражаться\n4) Спать")
		var act string
		fmt.Scanf("%s\n", &act)
		switch act {
		case "1":
			dig()
		case "2":
			eat()
		case "3":
			fight()
		case "4":
			sleep()
		default:
			continue
		}
		if Health <= 0 || Burrow <= 0 || Respect <= 0 || Weight <= 0 {
			fmt.Println("Крот умер...")
			break
		}
		if Respect > 100 {
			fmt.Println("Крота зауважали, победа!")
			break
		}
		fmt.Println("Ночь...")

		sleep()
	}
}

func sleep() {
	Burrow -= 2
	Health += 20
	Respect -= 2
	Weight -= 5
}

func params() {
	fmt.Println(fmt.Sprintf(
		"Ваши характеристики:\n Здоровье: %d\n Нора: %d\n Уважение: %d\n Вес: %d\n",
		Health, Burrow, Respect, Weight))
}

func dig() {
	var act string
	fmt.Println("Как копать?\n1) Интенсивно\n2) Лениво")
	fmt.Scanf("%s\n", &act)
	switch act {
	case "1":
		Burrow += 5
		Health -= 30
	case "2":
		Burrow += 2
		Health -= 10
	default:
		dig()
		return
	}
}
func eat() {
	var act string
	fmt.Println("Какую траву будем кушать?\n1) Жухлая\n2) Зеленая")
	fmt.Scanf("%s\n", &act)
	switch act {
	case "1":
		Health += 10
		Weight += 15
	case "2":
		if Respect < 30 {
			Health -= 30
		} else {
			Health += 30
			Weight += 30
		}
	default:
		eat()
		return
	}
}

func fight() {
	var act string
	fmt.Println("Какую сложность хотите?\n1) легко\n2) нормально\n3) сложно")
	fmt.Scanf("%s\n", &act)
	switch act {
	case "1":
		if rand.Float32() < float32(Weight/(Weight+30)) {
			fmt.Println("Крот победил в бою")
			Respect += rand.Intn(15-2) + 2
		} else {
			Health -= rand.Intn(35-15) + 15
			fmt.Println("Крота избили")
		}
	case "2":
		if rand.Float32() < float32(Weight/(Weight+50)) {
			fmt.Println("Крот победил в бою")
			Respect += rand.Intn(25-12) + 12
		} else {
			Health -= rand.Intn(55-25) + 25
			fmt.Println("Крота избили")
		}
	case "3":
		if rand.Float32() < float32(Weight/(Weight+70)) {
			fmt.Println("Крот победил в бою")
			Respect += rand.Intn(45-25) + 25
		} else {
			Health -= rand.Intn(75-45) + 45
			fmt.Println("Крота избили")
		}
	default:
		fight()
		return
	}
}
