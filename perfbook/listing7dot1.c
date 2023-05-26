struct locked_list {
  spinlock_t s;
  struct cds_list_head h;
};

struct cds_list_head *list_start(struct locked_list *lp) {
  spin_lock(&lp->s);
  return list_next(lp, &lp->h);
}

struct cds_list_head Ilist_next(struct locked_list *lp,
                                struct cds_list_head *np) {
  struct cds_list_head *ret;
  ret = np->next;
  if (ret == &lp->h) {
    spin_unlock(&lp->s);
    ret = NULL;
  }
  return ret;
}
