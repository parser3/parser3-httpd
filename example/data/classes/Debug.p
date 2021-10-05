# Parser Debug Library
# Copyright Art. Lebedev | http://www.artlebedev.ru/
# Author: vlalek, gregory
# Updated: 2016-09-29


@dd[*o]
$result[^Debug:_stop[$o]]


@dstop[*o]
$result[^Debug:_stop[$o]]


@dshow[*o]
$result[^Debug:_show[$o]]


@CLASS
Debug

@OPTIONS
locals


@auto[]
$self.long_string_length(1500)

$can[$MAIN:isDeveloper]

^if($can is junction){
	$self.can(^can[])
}(def $can){
	$self.can($can)
}{
	$self.can(true)
}

$self.status[
	$.usage[
		$.begin[$status:rusage]
	]
	$.memory[
		$.end(0)
	]
]

$self._processed[^hash::create[]]


@stop[*o]
$result[^self._stop[$o]]


@show[*o]
$result[^self._show[$o]]


@_stop[o]
^if($self.can){
	^process[$MAIN:CLASS]{@unhandled_exception[exception^;stack]^#0a^^Debug:_exception[^$exception^;^$stack]}
	$result[^self._show[$o]^throw[debug;$self.console]]
}{
	$result[]
}


@_show[o][result]
^if($self.can){
	^if(!$self.called){
		^if($MAIN:postprocess is junction){
			$self._original_postprocess[$MAIN:postprocess]
		}
		$t[^process[$MAIN:CLASS]{@postprocess[result]^#0a^$result[^^Debug:_postprocess[^$result]]}]
		$self.called(true)
	}
	$self.status.memory.end($status:memory.used)
	$self.status.usage.end[$status:rusage]
	$usage((^self.status.usage.end.tv_sec.double[] - ^self.status.usage.begin.tv_sec.double[]) + (^self.status.usage.end.tv_usec.double[] - ^self.status.usage.begin.tv_usec.double[])/1000000)
	$utime($self.status.usage.end.utime - $self.status.usage.begin.utime)

	^if(!($o is hash)){$o[$.void[$o]]}

	$self.console[
		${self.console}
		<div class="parser_debug_show"><table><tr>^o.foreach[k;v]{<td><pre>^if($v is double){^self._show_double[$v;](true)}{^self.__show[$v;](true)}</pre></td>}[<td class="parser_debug_separator"></td>]</tr></table>
		<b>memory used: $self.status.memory.end KB, usage: ^usage.format[%.3f] s, utime: ^utime.format[%.3f] s^if(def $self.status.prev){ ^($f($self.status.memory.end - $self.status.prev.memory)$f KB, $f($usage - $self.status.prev.usage)^f.format[%.3f] s, $f($utime - $self.status.prev.utime)^f.format[%.3f] s^)}</b></div>
	]

	$self.status.prev[
		$.memory($self.status.memory.end)
		$.usage($usage)
		$.utime($utime)
	]
}


@__show[o;indent;root]
^if($self.[_show_$o.CLASS_NAME] is junction){
	$result[^Debug:[_show_$o.CLASS_NAME][$o;$indent;$root]]
}{
	$result[^Debug:_show_DEFAULT[$o;$indent;$root]]
}


@_show_junction[o;i;root]
$result[^self._show_OUTER[^{;;;<b title="junction">junction</b>;;^};$root]]


@_show_double[o;i;root]
$result[^self._show_OUTER[^(;;;<u title="double">$o</u>;;^);$root]]


@_show_bool[o;i;root]
$result[^self._show_OUTER[^(;;;<b title="bool">^if($o){true}{false}</b>;;^);$root]]


@_show_string[o;i;root]
$s[^o.match[<;g;&lt^;]]
$result[^self._show_OUTER[^[;;;^if(^o.length[] > $self.long_string_length){<ins string="true"><tt>^taint[as-is][$s]</tt></ins>}{<tt>^taint[as-is][$s]</tt>};;^];$root]]


@_show_date[o;i;root]
$result[^self._show_OUTER[^[;date;^[;${o.year}-^o.month.format[%02d]-^o.day.format[%02d] ^o.hour.format[%02d]:^o.minute.format[%02d]:^o.second.format[%02d]</b>;^];^];$root]]


@_show_file[o;i;root]
$s[^file:fullpath[$o.name]]
$result[^self._show_OUTER[^[;;;<u title="file: $o.mode, $o.size B">^if(def $s){$s}{file}</u>;;^];$root]]


@_show_image[o;i;root]
^if(!def $o.src){
	$result[^self._show_OUTER[^[;image;^[;;^];^];$root]]
}{
	$result[^self._show_OUTER[^[;;;<img src="$o.src" alt="" title="$o.src $o.width&times^;$o.height"/>;;^];$root]]
}


@_show_void[o;i;root]
$result[^self._show_OUTER[^[;;;<u>void</u>;;^];$root]]


@_show_table[o;i;root]
$c[^o.columns[]]
^if(!$c){
	$n[[nameless]]
	$t[^o.flip[]]
	$ii(^t.count[] - 1)
	$c[^table::create{column}]
	^for[i](0;$ii){^c.append{$i}}
}
$result[^self._show_OUTER[^[;table;$n^{;<ins class="parser_debug_hidden" table="true"><table border="1" class="parser_debug_table">^if(!$t){
	<tr>^c.menu{<th>$c.column</th>}</tr>}
	^o.menu{<tr>^c.menu{<td>$s[$o.fields.[$c.column]]^s.match[<;g;&lt^;]</td>}</tr>}
</table></ins>;^};^];$root]]


@_show_regex[o;i;root]
$result[^self._show_OUTER[^[;regex;^[;$o.pattern^;$o.options;^];^];$root]]


@_show_xdoc[o;i;root]
$s[^self.xml_string[^o.string[$.omit-xml-declaration[no] $.method[xml] $.indent[yes]]]]
$result[^self._show_OUTER[^[;xdoc;^{;<ins class="parser_debug_hidden" xdoc="true">^s.match[<;g;&lt^;]</ins>;^};^];$root]]


@_show_xnode[o;i;root]
$result[^self._show_OUTER[^[;;;<u title="xnode">^self.xnode_string[$o]</u>;;^];$root]]


@xnode_string[o]
^switch[$o.nodeType]{
	^case[1]{
		$a[^o.select[@*]]
		$a[^a.foreach[k;v]{^self.xnode_string[$v]}]
		$c[^o.select[* | text()]]
		$c[^c.foreach[k;v]{^self.xnode_string[$v]}]
		$result[&lt^;${o.nodeName}$a^if(!def $c){/&gt^;}{&gt^;$c&lt^;/$o.nodeName&gt^;}]
	}
	^case[2]{$result[^#20$o.nodeName="^self.xml_string[^apply-taint[xml][$o.nodeValue]]"]}
	^case[DEFAULT]{$result[^self.xml_string[^apply-taint[xml][$o.nodeValue]]]}
}]


@xml_string[result]
$result[^result.match[&;g;&amp^;]]


@_show_hash[o;indent;root]
$s[^self._show_OBJECT[$o;$indent]]
$result[^self._show_OUTER[^[;^if(!def $s){hash};^[;$s;^];^];$root]]


@_show_Array[o;indent;root]
$s[^self._show_OBJECT[$o.array;$indent]]
$result[^self._show_OUTER[^[;^if(!def $s){hash};^[;$s;^];^];$root]]


@_show_DEFAULT[o;indent;root]
$result[^self._show_OUTER[^[;$o.CLASS_NAME;^[;^self._show_OBJECT[^reflection:fields[$o];$indent];^];^];$root]]


@_show_OUTER[prefix;class_name;p;value;s;suffix;root]
$result[^if(!$root){$prefix}^if(def $class_name){<u>^^${class_name}::create</u>$p}$value^if(def $class_name){$s}^if(!$root){$suffix}]


@_show_OBJECT[o;indent;root]
$result[]
$keys[^o._keys[]]
$ouid[^reflection:uid[$o]]
^if(!^self._processed.contains[$ouid]){
	$self._processed.$ouid[root]
}
^keys.menu{
	$k[$keys.key]
	$result[$result^taint[as-is][^#0a$indent^#09]<a>^$.^if(^k.match[[-.\s^;\^]^}^)"<>#+*/%&|=!',?]]){[$k]}{$k}</a>]
	^try{
		^if($o.$k is double){
			$v($o.$k)
		}{
			$v[$o.$k]
		}
		^if($v is double){
			$result[$result^self.__show($v)]
		}(!($v is junction)){
			$uid[^reflection:uid[$v]]
			^if(!^self._processed.contains[$uid]){
				$self._processed.$uid[ancestor property ^$.$k]
				$result[$result^self.__show[$v;$indent^#09]]
				^self._processed.delete[$uid]
			}{
				$result[${result}^[<b>UID: $uid was in $self._processed.$uid</b>^]]
			}
		}{
			$result[$result^self.__show[$v;$indent^#09]]
		}
	}{
		$exception.handled(true)
		$result[${result}^{<b title="junction">junction</b>^}]
	}
}
^if($o){
	$l(^indent.length[])
	$result[<ins^if($root){ root="true"}>$result^taint[as-is][^#0a$indent]</ins>]
}
^self._processed.delete[$ouid]


@_postprocess[result]
^if($self._original_postprocess is junction){
	$result[^Debug:_original_postprocess[$result]]
}
^if($response:[content-type] is string){
	$type[$response:[content-type]]
}{
	$type[$response:[content-type].value]
}
^if($self.called && ($type eq "text/html" || !^type.match[/(xml|json)])){
	$result[^result.match[(^^.*<(?:html|body)[^^>]*>)?][i]{$match.1^self._outer_html[${Debug:console}]}]
}


@_exception[exception;stack]
$response:status(200)
$response:content-type[
	$.value[text/html]
	$.charset[$response:charset]
]
^self._outer_html[
	^if($exception.type eq debug){
		<div class="parser_debug_console">^untaint{$exception.source}</div>
	}{
		<pre>^untaint[html]{ $exception.comment }</pre>
		^if(def $exception.source){
			<b>$exception.source</b><br>
			<pre>^untaint[html]{$exception.file^($exception.lineno^)}</pre>
		}
		^if(def $exception.type){ exception.type=$exception.type }
	}
	^if($stack is table){
		<hr/>
		<table class="parser_debug_stack">
		^stack.menu{
			^if($exception.type eq debug && ^stack.line[] < 5 && $stack.name ne rem){}{<tr><th>^^$stack.name</th><td>^file:dirname[$stack.file]/<b>^file:basename[$stack.file] [$stack.lineno]</b> [$stack.colno]</td></tr>}
		}
		</table>
	}
	</div>
]


@_outer_html[html]
<div id="parser_debug" style="display: none">
$html
</div>
<style>
	#parser_debug {box-sizing: border-box; background-color: #eee; font-size: 12px; font-family: monospace; padding: 0.5em 1em; position: fixed; z-index: 88888; top: 0; left: 0; width: 100%; height: 100%; overflow: auto;}
	#parser_debug th, #parser_debug td {vertical-align: top; text-align: left; font-weight: normal; padding: 0.25em;}
	.parser_debug_show {margin: 0 0 1.5em;padding: 0 0 1.5em;border-bottom: 1px dashed #555;}
	.parser_debug_show:first-child{margin-top: 1.5em; padding-top: 1.5em; border-top: 1px dashed #555;}
	.parser_debug_show:last-child {border-bottom: 0;}
	.parser_debug_show pre {color: #555; font-size: inherit; line-height: 1.4;}
	.parser_debug_show i, .parser_debug_show s, .parser_debug_show b, .parser_debug_show a, .parser_debug_show u {text-decoration: none; font-weight: normal; display: inline; color: #000;}
	.parser_debug_show i {font-size: 50%;}
	.parser_debug_show a {color: #099;}
	.parser_debug_show s {color: #909;}
	.parser_debug_show b {color: #00f;}
	.parser_debug_show u {color: #009;}
	.parser_debug_show ins {text-decoration: none;}
	.parser_debug_show img {max-width: 64px; max-height: 64px;}
	.parser_debug_foldable {border-bottom: 1px dotted; cursor: pointer;}
	.parser_debug_foldable:hover, .parser_debug_foldable:hover * {color: #c00;}
	.parser_debug_hidden:before {content: '...'; color: #909;}
	.parser_debug_hidden {height: 1em; width: 1.8em; display: inline-block; overflow: hidden;}
	.parser_debug_show table {border-collapse: collapse; margin: 0; vertical-align: top;}
	.parser_debug_table, .parser_debug_table th, .parser_debug_table td {border: 1px dotted #999; color: #555;}
	#parser_debug .parser_debug_table th {font-weight: bold; color: #333}
	.parser_debug_separator {padding: 0 0 0 0.1em ! important; border-left: 1px dotted #00f;}
	.parser_debug_stack th {color: #099;}
	.parser_debug_stack td {color: #777;}
	.parser_debug_stack b {color: #000; font-weight: normal;}
</style>
<script>
	(function(){
		var parser_debug_foldable = function(el){
			var next_el = el, o, tag;
			while(next_el = next_el.nextSibling){
				if(next_el.nodeType == 1){
					tag = next_el.tagName.toLowerCase();
					if(tag == 'ins'){
						o = {el: el, text: el.innerText, hidden: next_el.classList.contains('parser_debug_hidden')};
						ao.push(o);
						el.onclick = function(){
							if(o.hidden){
								next_el.className = '';
								o.hidden = false;
							}else{
								next_el.className = 'parser_debug_hidden';
								o.hidden = true;
							}
							return false;
						}
						el.className += ' parser_debug_foldable';
						if(
							next_el.parentNode.tagName.toLowerCase() === 'ins'
							&& next_el.innerHTML.replace(/(<\/?[a-z][^^>]+>|\s+)/g, '').length > $self.long_string_length
						){
							el.onclick();
						}
						break;
					}else if(tag == 'a'){
						break;
					}
				}
			}
		};
		var d = document.getElementById('parser_debug'),
			p = d.getElementsByTagName('pre');

		for(var i = 0; i < p.length; i++){
			p[i].innerHTML = p[i].innerHTML
				.replace(
					/<a([^^>]*)>\^$\.\[(.+?)\]<\/a>/g,
					'<s>^$.[</s><a^$1>^$2</a><s>]</s>'
				)
				.replace(
					/<a([^^>]*)>\^$\.(.+?)<\/a>/g,
					'<s>^$.</s><a^$1>^$2</a>'
				)
				.replace(
					/<u([^^>]*)>\^^(image|xdoc|table|hash|file|void|date|regex)::create<\/u>/g,
					'<u^$1>^^<b>^$2</b>::create</u>'
				)
				.replace(
					/<u([^^>]*)>\^^(\S+)::create<\/u>/g,
					'<s>^^</s><u^$1>^$2<s>::</s>create</u>'
				)
				.replace(/(\t+)/g, '<i>^$1</i>')
		}

		var a = d.getElementsByTagName('a'), ao = [], b = window.HTMLElement ? window : body;

		for(var i = 0, ii = a.length; i < ii; i++){
			parser_debug_foldable(a[i]);
		}
		if(d.getElementsByTagName('hr')[0]){
			d.style.display = '';
		}else{
			b.onkeydown = function(e){
				e = e || window.event;
				if((e.ctrlKey || e.metaKey) && (e.keyCode == 192 || e.keyCode == 96 || e.keyCode == 191)){
					d.style.display = d.style.display == 'none' ? '' : 'none';
				}
			};
		}
		b.onhashchange = function(e){
			var c = location.hash.replace(/^^#/, '').split(/\s+/), m, mm;
			for(var i = 0; i < c.length; i++){
				m = c[i].match(/^^(show|hide)=(.+)/);
				if(m){
					mm = new RegExp('(' + m[2] + ')')
					for(var j = 0, jj= ao.length; j < jj; j++){
						if(
							ao[j].text.match(mm)
							&& (
								(m[1] == 'show' && ao[j].hidden)
								|| (m[1] == 'hide' && !ao[j].hidden)
							)
						){
							ao[j].el.onclick();
						}
					}
				}
			}
		};
		b.onhashchange();
	})();
</script>
