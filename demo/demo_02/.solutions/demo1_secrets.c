
char* NOT_SO_SECRET_KEY = "not_so_secret_key_42";

extern int check_result;
extern void find_me(void);

void __attribute__((constructor)) __initi() {
  check_result = (((int)&find_me) ^ 0x3184a39);
}
