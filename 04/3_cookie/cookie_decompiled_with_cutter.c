/* Ghidra Output */

int main(int argc,char **argv,char **envp){
  puts("COOOOKKIIEEESSS!");
  give_cookie();
  return 0;
}



/* WARNING: Could not reconcile some variable overlaps */

void give_cookie(void)

{
  int iVar1;
  long in_FS_OFFSET;
  undefined8 local_60;
  undefined8 local_58;
  undefined8 local_50;
  undefined8 local_48;
  undefined8 local_40;
  undefined8 local_38;
  undefined8 local_30;
  undefined8 local_28;
  undefined8 local_20;
  long local_10;
  
  local_10 = *(long *)(in_FS_OFFSET + 0x28);
  local_60 = 0;
  local_58 = 0;
  local_50 = 0;
  local_48 = 0;
  local_40 = 0;
  local_38 = 0;
  local_30 = 0;
  local_28 = 0;
  local_20 = 0;
  do {
    puts("What kind of cookie do you want?");
    local_58 = 0;
    local_50 = 0;
    local_48 = 0;
    local_40 = 0;
    local_38 = 0;
    local_30 = 0;
    local_28 = 0;
    local_20 = 0;
    read(0,&local_58,100);
    iVar1 = strcmp((char *)&local_58,"chocolate\n");
    if (iVar1 == 0) {
      puts("There you go a: \xf0\x9f\x8d\xaa\x00");
    }
    else {
      iVar1 = strcmp((char *)&local_58,"pizza\n");
      if (iVar1 == 0) {
        puts("Technically not a cookie, but ok: \xf0\x9f\x8d\x95\x00\x00");
      }
      else {
        iVar1 = strcmp((char *)&local_58,"fortune\n");
        if (iVar1 == 0) {
          puts("There you go a: \xf0\x9f\xa5\xa0\x00");
        }
        else {
          iVar1 = strcmp((char *)&local_58,"rice\n");
          if (iVar1 == 0) {
            puts("Pretty boring...: \xf0\x0f\x8d\x98\x00");
          }
          else {
            printf("You asked for a \"%s\" cookie...",&local_58);
            puts("Sorry, but I don\'t know that type of cookie :(");
          }
        }
      }
    }
    puts("Another one? (y/n)");
    read(0,&local_60,7);
  } while ((char)local_60 == 'y');
  puts("OK. Then enjoy your cookies! Bye.");
  if (local_10 == *(long *)(in_FS_OFFSET + 0x28)) {
    return;
  }
                    /* WARNING: Subroutine does not return */
  __stack_chk_fail();
}

