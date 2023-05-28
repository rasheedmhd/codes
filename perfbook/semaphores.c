// SCENERIO ONE - SAFE

typedef int semaphore;
semaphore resource_1;
semaphore resource_2;

void process_A(void) {
  down(&resource_1);
  down(&resource_2);
  use_both_resources();
  up(&resource_2);
  up(&resource_1)
}

void process_B(void) {
  down(&resource_1);
  down(&resource_2);
  use_both_resources();
  up(&resource_2);
  up(&resource_1)
}

// SCENERIO TWO - POTENTIAL DEADLOCK
semaphore resource_1;
semaphore resource_2;

void process_A(void) {
  down(&resource_1);
  down(&resource_2);
  use_both_resources();
  up(&resource_2);
  up(&resource_1)
}

void process_A(void) {
  down(&resource_2);
  down(&resource_1);
  use_both_resources();
  up(&resource_1);
  up(&resource_2)
}
