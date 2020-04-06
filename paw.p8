pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--setup
gravity=0.4
friction=0.65
	
function _init()
	restart()
end

function restart()
	p={}
	p.x=59
	p.y=59
	p.w=8
	p.h=8
	p.dx=0
	p.dy=0
	p.max_dx=2
	p.max_dy=4
	p.acc_x=0.85
	p.acc_y=3
	p.flipx=false
	p.on_floor=false
	set_anim(p,"idle")
end

function set_anim(p,name)
	local a={ name=name, t=time() }
	if name=="idle" then
		a.f0=0
		a.f1=1
		a.dt=0.5
	elseif name=="run" then
		a.f0=3
		a.f1=6
		a.dt=0.125
	end
	p.anim=a
	p.spr=a.f0
end


-->8
--update
function _update()
	local p=p
	
	--general
	p.dy+=gravity
	p.dx*=friction
	
	--controls
	if p.on_floor and btnp(❎) then
		p.on_floor=false
		p.dy=-p.acc_y
	elseif btn(⬅️) then
		p.dx-=p.acc_x
	elseif btn(➡️) then
		p.dx+=p.acc_x
	end
	
	--limits
	p.dx=mid(-p.max_dx,p.dx,p.max_dx)
	p.dy=mid(-p.max_dy,p.dy,p.max_dy)
	
	--position
	p.x+=p.dx
	p.y+=p.dy
	
	--bounds collision
	p.x=mid(0,p.x,120)
	if p.y>120-p.h then
		p.on_floor=true
		p.y=120-p.h
	end
	
	--zero low dx
	if abs(p.dx)<0.1 then p.dx=0 end
	
	--animation
	local anim=p.anim.name
	if p.on_floor then
		if p.dx!=0 and anim!="run" then
			set_anim(p, "run")
		elseif p.dx==0 and anim!="idle" then
			set_anim(p, "idle")
		end
	else
		p.anim={ name="none" }
		if p.dy>0 then
			p.spr=10	
		else
			p.spr=8
		end
	end
	update_anim(p)
	
	--direction
	if p.dx<0 then
		p.flipx=true
	elseif p.dx>0 then
		p.flipx=false
	end
end

function update_anim(p)
	local a=p.anim
	if a.name=="none" then return end
	if time()-a.t>a.dt then
		a.t=time()
		p.spr+=1
		if p.spr>a.f1 then
			p.spr=a.f0 --wrap around
		end
	end
end
-->8
--draw
function _draw()
	cls()
 map(0,0)
 spr(p.spr,p.x,p.y,1,1,p.flipx)
	--rect(p.x,p.y,p.x+p.w-1,p.y+p.h-1,7)
	print("dx "..p.dx,1,1,7)
	print("dy "..p.dy,1,9,7)
end

-->8
--dither
dither={
 0x1000.0000,
	0x1000.8000,
	0x1000.8020,
	0x1000.a020,
	0x1000.a0a0,
	0x1000.a4a0,
	0x1000.a4a1,
	0x1000.a5a1,
	0x1000.a5a5,
	0x1000.e5a5,
	0x1000.e5b5,
	0x1000.f5b5,
	0x1000.f5f5,
	0x1000.fdf5,
	0x1000.fdf7,
	0x1000.fff7,
	0x1000.ffff
}

function draw_gradient(y,colors)
	local d=dither
	local p=1
 while y<128 do
 	rectfill(0,y,127,y+3,colors+d[p])
  y+=4
  p=min(p+1,17)
 end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00090110000901100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00041400000414000009011000090011000090110009011000090110000000000000001100090011000901100000000000000000000000000000000000000000
00004990000049900004140000004140000041400004140004041400000901100009414000004140040414000009011000000000000000000000000000000000
00001100000011000400499000000499044004994400499004004990040414000000049900000499041049900404140000000000000000000000000000000000
0001a4000001a400041a10000441a1000001a100094a1000001a1000040049900041a1000441a100094a1000041a499000000000000000000000000000000000
00011400040114000041100000041190009411000011100000411000001a10000404119000941190000110000041100000000000000000000000000000000000
04449990004499900090900000900000000009000009000000990000009119000009000000000000000090000009900000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
666666d6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dbdddd1d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3bbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbb3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb3b3bbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbb4bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202020202020202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
