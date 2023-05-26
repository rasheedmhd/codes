struct locked_list {
  spinlock_t s;
  struct cds_list_head h;
};

struct cds_list_head *list_start(struct locked_list *lp) {
  spin_lock(&lp->s);
  return list_next(lp, &lp->h);
}

struct cds_list_head list_next(struct locked_list *lp,
                               struct cds_list_head *np) {
  struct cds_list_head *ret;
  ret = np->next;
  if (ret == &lp->h) {
    spin_unlock(&lp->s);
    ret = NULL;
  }
  return ret;
}

// listing 7.2
struct list_ints {
  struct cds_list_head n;
  int a;
};

void list_print(struct locked_list *lp) {
  struct cds_list_head *np;
  struct list_ints *ip;

  np = list_start(lp);
  while (np != NULL) {
    ip = cds_list_entry(np, struct list_ints, n);
    printf("\t%d\n", ip->a);
    np = list_next(lp, np);
  }
}
