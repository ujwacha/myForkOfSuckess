/* Key binding functions */
static void defaultgaps(const Arg *arg);
static void incrgaps(const Arg *arg);
static void incrogaps(const Arg *arg);
static void togglegaps(const Arg *arg);
/* Layouts (delete the ones you do not need) */
static void centeredmaster(Monitor *m);
static void centeredfloatingmaster(Monitor *m);
/* Internals */
static void getgaps(Monitor *m, int *oh, int *ov, int *ih, int *iv, unsigned int *nc);
static void getfacts(Monitor *m, int msize, int ssize, float *mf, float *sf, int *mr, int *sr);
static void setgaps(int oh, int ov, int ih, int iv);

/* Settings */
#if !PERTAG_PATCH
static int enablegaps = 1;
#endif // PERTAG_PATCH

void
setgaps(int oh, int ov, int ih, int iv)
{
	if (oh < 0) oh = 0;
	if (ov < 0) ov = 0;
	if (ih < 0) ih = 0;
	if (iv < 0) iv = 0;

	selmon->gappoh = oh;
	selmon->gappov = ov;
	selmon->gappih = ih;
	selmon->gappiv = iv;
	arrange(selmon);
}

void
togglegaps(const Arg *arg)
{
	#if PERTAG_PATCH
	selmon->pertag->enablegaps[selmon->pertag->curtag] = !selmon->pertag->enablegaps[selmon->pertag->curtag];
	#else
	enablegaps = !enablegaps;
	#endif // PERTAG_PATCH
	arrange(NULL);
}

void
defaultgaps(const Arg *arg)
{
	setgaps(gappoh, gappov, gappih, gappiv);
}

void
incrgaps(const Arg *arg)
{
	setgaps(
		selmon->gappoh + arg->i,
		selmon->gappov + arg->i,
		selmon->gappih + arg->i,
		selmon->gappiv + arg->i
	);
}


void
incrogaps(const Arg *arg)
{
	setgaps(
		selmon->gappoh + arg->i,
		selmon->gappov + arg->i,
		selmon->gappih,
		selmon->gappiv
	);
}



void
getgaps(Monitor *m, int *oh, int *ov, int *ih, int *iv, unsigned int *nc)
{
	unsigned int n, oe, ie;
	#if PERTAG_PATCH
	oe = ie = selmon->pertag->enablegaps[selmon->pertag->curtag];
	#else
	oe = ie = enablegaps;
	#endif // PERTAG_PATCH
	Client *c;

	for (n = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), n++);
	if (smartgaps && n == 1) {
		oe = 0; // outer gaps disabled when only one client
	}

	*oh = m->gappoh*oe; // outer horizontal gap
	*ov = m->gappov*oe; // outer vertical gap
	*ih = m->gappih*ie; // inner horizontal gap
	*iv = m->gappiv*ie; // inner vertical gap
	*nc = n;            // number of clients
}

void
getfacts(Monitor *m, int msize, int ssize, float *mf, float *sf, int *mr, int *sr)
{
	unsigned int n;
	float mfacts = 0, sfacts = 0;
	int mtotal = 0, stotal = 0;
	Client *c;

	for (n = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), n++)
		if (n < m->nmaster)
			mfacts += c->cfact;
		else
			sfacts += c->cfact;

	for (n = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), n++)
		if (n < m->nmaster)
			mtotal += msize * (c->cfact / mfacts);
		else
			stotal += ssize * (c->cfact / sfacts);

	*mf = mfacts; // total factor of master area
	*sf = sfacts; // total factor of stack area
	*mr = msize - mtotal; // the remainder (rest) of pixels after a cfacts master split
	*sr = ssize - stotal; // the remainder (rest) of pixels after a cfacts stack split
}

/***
 * Layouts
 */


/*
 * Centred master layout + gaps
 * https://dwm.suckless.org/patches/centeredmaster/
 */
void
centeredmaster(Monitor *m)
{
	unsigned int i, n;
	int oh, ov, ih, iv;
	int mx = 0, my = 0, mh = 0, mw = 0;
	int lx = 0, ly = 0, lw = 0, lh = 0;
	int rx = 0, ry = 0, rw = 0, rh = 0;
	float mfacts = 0, lfacts = 0, rfacts = 0;
	int mtotal = 0, ltotal = 0, rtotal = 0;
	int mrest = 0, lrest = 0, rrest = 0;
	Client *c;

	getgaps(m, &oh, &ov, &ih, &iv, &n);
	if (n == 0)
		return;

	/* initialize areas */
	mx = m->wx + ov;
	my = m->wy + oh;
	mh = m->wh - 2*oh - ih * ((!m->nmaster ? n : MIN(n, m->nmaster)) - 1);
	mw = m->ww - 2*ov;
	lh = m->wh - 2*oh - ih * (((n - m->nmaster) / 2) - 1);
	rh = m->wh - 2*oh - ih * (((n - m->nmaster) / 2) - ((n - m->nmaster) % 2 ? 0 : 1));

	if (m->nmaster && n > m->nmaster) {
		/* go mfact box in the center if more than nmaster clients */
		if (n - m->nmaster > 1) {
			/* ||<-S->|<---M--->|<-S->|| */
			mw = (m->ww - 2*ov - 2*iv) * m->mfact;
			lw = (m->ww - mw - 2*ov - 2*iv) / 2;
			rw = (m->ww - mw - 2*ov - 2*iv) - lw;
			mx += lw + iv;
		} else {
			/* ||<---M--->|<-S->|| */
			mw = (mw - iv) * m->mfact;
			lw = 0;
			rw = m->ww - mw - iv - 2*ov;
		}
		lx = m->wx + ov;
		ly = m->wy + oh;
		rx = mx + mw + iv;
		ry = m->wy + oh;
	}

	/* calculate facts */
	for (n = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), n++) {
		if (!m->nmaster || n < m->nmaster)
			mfacts += c->cfact;
		else if ((n - m->nmaster) % 2)
			lfacts += c->cfact; // total factor of left hand stack area
		else
			rfacts += c->cfact; // total factor of right hand stack area
	}

	for (n = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), n++)
		if (!m->nmaster || n < m->nmaster)
			mtotal += mh * (c->cfact / mfacts);
		else if ((n - m->nmaster) % 2)
			ltotal += lh * (c->cfact / lfacts);
		else
			rtotal += rh * (c->cfact / rfacts);

	mrest = mh - mtotal;
	lrest = lh - ltotal;
	rrest = rh - rtotal;

	for (i = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), i++) {
		if (!m->nmaster || i < m->nmaster) {
			/* nmaster clients are stacked vertically, in the center of the screen */
			resize(c, mx, my, mw - (2*c->bw), mh * (c->cfact / mfacts) + (i < mrest ? 1 : 0) - (2*c->bw), 0);
			my += HEIGHT(c) + ih;
		} else {
			/* stack clients are stacked vertically */
			if ((i - m->nmaster) % 2 ) {
				resize(c, lx, ly, lw - (2*c->bw), lh * (c->cfact / lfacts) + ((i - 2*m->nmaster) < 2*lrest ? 1 : 0) - (2*c->bw), 0);
				ly += HEIGHT(c) + ih;
			} else {
				resize(c, rx, ry, rw - (2*c->bw), rh * (c->cfact / rfacts) + ((i - 2*m->nmaster) < 2*rrest ? 1 : 0) - (2*c->bw), 0);
				ry += HEIGHT(c) + ih;
			}
		}
	}
}

void
centeredfloatingmaster(Monitor *m)
{
	unsigned int i, n;
	float mfacts, sfacts;
	float mivf = 1.0; // master inner vertical gap factor
	int oh, ov, ih, iv, mrest, srest;
	int mx = 0, my = 0, mh = 0, mw = 0;
	int sx = 0, sy = 0, sh = 0, sw = 0;
	Client *c;

	getgaps(m, &oh, &ov, &ih, &iv, &n);
	if (n == 0)
		return;

	sx = mx = m->wx + ov;
	sy = my = m->wy + oh;
	sh = mh = m->wh - 2*oh;
	mw = m->ww - 2*ov - iv*(n - 1);
	sw = m->ww - 2*ov - iv*(n - m->nmaster - 1);

	if (m->nmaster && n > m->nmaster) {
		mivf = 0.8;
		/* go mfact box in the center if more than nmaster clients */
		if (m->ww > m->wh) {
			mw = m->ww * m->mfact - iv*mivf*(MIN(n, m->nmaster) - 1);
			mh = m->wh * 0.9;
		} else {
			mw = m->ww * 0.9 - iv*mivf*(MIN(n, m->nmaster) - 1);
			mh = m->wh * m->mfact;
		}
		mx = m->wx + (m->ww - mw) / 2;
		my = m->wy + (m->wh - mh - 2*oh) / 2;

		sx = m->wx + ov;
		sy = m->wy + oh;
		sh = m->wh - 2*oh;
	}

	getfacts(m, mw, sw, &mfacts, &sfacts, &mrest, &srest);

	for (i = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), i++)
		if (i < m->nmaster) {
			/* nmaster clients are stacked horizontally, in the center of the screen */
			resize(c, mx, my, mw * (c->cfact / mfacts) + (i < mrest ? 1 : 0) - (2*c->bw), mh - (2*c->bw), 0);
			mx += WIDTH(c) + iv*mivf;
		} else {
			/* stack clients are stacked horizontally */
			resize(c, sx, sy, sw * (c->cfact / sfacts) + ((i - m->nmaster) < srest ? 1 : 0) - (2*c->bw), sh - (2*c->bw), 0);
			sx += WIDTH(c) + iv;
		}
}

/*
 * Default tile layout + gaps
 */
static void
tile(Monitor *m)
{
	unsigned int i, n;
	int oh, ov, ih, iv;
	int mx = 0, my = 0, mh = 0, mw = 0;
	int sx = 0, sy = 0, sh = 0, sw = 0;
	float mfacts, sfacts;
	int mrest, srest;
	Client *c;

	getgaps(m, &oh, &ov, &ih, &iv, &n);
	if (n == 0)
		return;

	sx = mx = m->wx + ov;
	sy = my = m->wy + oh;
	mh = m->wh - 2*oh - ih * (MIN(n, m->nmaster) - 1);
	sh = m->wh - 2*oh - ih * (n - m->nmaster - 1);
	sw = mw = m->ww - 2*ov;

	if (m->nmaster && n > m->nmaster) {
		sw = (mw - iv) * (1 - m->mfact);
		mw = mw - iv - sw;
		sx = mx + mw + iv;
	}

	getfacts(m, mh, sh, &mfacts, &sfacts, &mrest, &srest);

	for (i = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), i++)
		if (i < m->nmaster) {
			resize(c, mx, my, mw - (2*c->bw), mh * (c->cfact / mfacts) + (i < mrest ? 1 : 0) - (2*c->bw), 0);
			my += HEIGHT(c) + ih;
		} else {
			resize(c, sx, sy, sw - (2*c->bw), sh * (c->cfact / sfacts) + ((i - m->nmaster) < srest ? 1 : 0) - (2*c->bw), 0);
			sy += HEIGHT(c) + ih;
		}
}
