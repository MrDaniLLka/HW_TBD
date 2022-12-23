package main

import (
	"fmt"
	"net"
	"sync"
	"sort"
)

// TODO: реализация в main не возвращает слайс открытых портов
// необходимо реализовать функцию Scan по по аналогии с кодом в main.go
// только её нужно дополнить, чтобы вернуть слайс открытых портов
// отсортированных по возрастанию

func Scan(address string) []int {
	availablePorts := make([]int, 0)
	ports := make(chan int, 200)
	
	wg := sync.WaitGroup{}

	for i := 0; i < cap(ports); i++ {
		go worker(ports, &wg, address, &availablePorts)
	}

	for i := 1; i < 10000; i++ {
		wg.Add(1)
		ports <- i
	}

	wg.Wait()
	close(ports) 
	
	sort.Ints(availablePorts)
	return availablePorts
}

func worker(address string, availablePorts *[]int, ports chan int, wg *sync.WaitGroup) {
	val mutex sync.Mutex
	for p := range ports {
		conn, err := net.Dial("tcp", fmt.Sprintf("%s:%d", address, p))
		if err != nil {
			wg.Done()
			continue
		}
		mutex.Lock()
		conn.Close()
		*availablePorts = append(*availablePorts, p)
		wg.Done()
		mutex.Unlock()
	}
}
