%\RequirePackage [ log-declarations = false ] { xparse }
\RequirePackage { expl3, l3keys2e }
\ProvidesExplClass {myexercise} {2013/11/16} {0.1}
    {Exercise solutions}
\RequirePackage { l3backports }


\def\ConfigOutput{print}
\PassOptionsToClass { oneside } { scrbook }
\PassOptionsToPackage { clines } { scrpage2 }
\LoadClass{mycourse}


\geometry {
	a4paper,
	left           = 20mm,
	right          = 20mm,
	top            = 12mm,
	bottom         = 20mm,
	marginparwidth = 18mm,
	marginparsep   =  3mm,
	includehead,
	includefoot
}

%
%\fancyhead{}
%\fancyfoot{}
%
%\fancyheadoffset[RE,LO]{0pt}
%\fancyhf{}
%\cfoot{\bfseries\color{header} \thepage~/~\pageref{LastPage}}

%\renewcommand{\headrulewidth}{0.4pt}
%\definecolor{headerrule}{HTML}{000000}
%\renewcommand{\headrule}{{\color{headerrule}%
%\hrule width\headwidth height\headrulewidth \vskip-\headrulewidth}}
\setheadsepline [ page ] { 0pt } [  ]
\clearscrheadfoot


\headheight 2em
\lohead { Einführung~in~die~Numerik~partieller~Differentialgleichungen \\ \today }
\rohead { Stephan~Hilb \\ ~2706616 }
\cfoot [ \pagemark ] { \pagemark }


\newtheoremstyle{myexercise}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			{\color{theoremtype}##1}\ \color{theoremnumber}##2\theorem@separator}\hbox{\strut}}}]}%
	{\item[\rlap{\vbox{\hbox{\hskip\labelsep \theorem@headerfont
			%{\color{theoremtype}##3}\ \color{theoremtitle}##3\theorem@separator}\hbox{\strut}}}]}
			{\color{theoremtype}##3}\theorem@separator}\hbox{\strut}}}]}

\theoremstyle{myexercise} 								% Vordefinierter Style mit Zeilenumbruch
\theorempreskipamount 2.5em 						% Abstand vor Theroem
\theoremindent 1em 									% Theroem einrücken
\theoremheaderfont{\kern-1em\normalfont\bfseries} 	% Überschrift wieder ausrücken
\theorembodyfont{\normalfont}
\newtheorem{exercise}{Aufgabe}[section]


\RequirePackage{kvoptions}
\DeclareStringOption[0]{sheet}
\DeclareOption{topo}{
	\addtolength{\headheight}{\baselineskip}
	\lhead{\textbf{Topologie} \\ \textit{Gruppe 1}}
	\chead{\textbf{Blatt \myexercise@sheet} \\ \textit{\coursedate\today}}
	\rhead{\textbf{\theauthor} \\ \textit{2706616}}
%
	\theoremstyle{myexercise} 								% Vordefinierter Style mit Zeilenumbruch
	\theorempreskipamount 2.5em 						% Abstand vor Theroem
	\theoremindent 1em 									% Theroem einrücken
	\theoremheaderfont{\kern-1em\normalfont\bfseries} 	% Überschrift wieder ausrücken
	\theorembodyfont{\normalfont}
	\newtheorem{exercise}{Aufgabe}[chapter]

	%\AtEndOfClass{
	%	\renewenvironment{aufgabe}{\refstepcounter{aufgabe}\par\medskip\noindent%
	%		\textbf{Aufgabe \thesection.\theaufgabe}\rmfamily}
	%	{\medskip}
	%}
}
\ProcessKeyvalOptions*
\ProcessOptions*


\setcounter{chapter}{\myexercise@sheet}

%\RequirePackage{l3keys2e}
%\ExplSyntaxOn
%\keys_define:nn{exercise}{
%	sheet .code:n = \def\sheetnumber#1
%}
%\keys_define:nn{exercise}{
%	top .code:n = 
%}
%\ExplSyntaxOff
%
%\ProcessKeysOptions{myexercise}

%\DeclareStringOption{sheet}
%\DeclareVoidOption{top}{
%	%\addtolength{\headheight}{\baselineskip}
%	%\lhead{\textbf{Topologie} \\ \textit{Gruppe 1}}
%	%\chead{\textbf{Blatt \myexercise@sheet} \\ \textit{\coursedate\today}}
%	%\rhead{\textbf{\theauthor} \\ \textit{2706616}}
%
%	%\renewenvironment{aufgabe}{\refstepcounter{aufgabe}\par\medskip\noindent%
%	%	\textbf{Aufgabe \thesection.\theaufgabe}\rmfamily}
%	%{\medskip}
%}
%
%\ProcessKeyvalOptions*


\usepackage{titling}

\author{Stephan Hilb}

%\theoremstyle{break}
%\theorembodyfont{\normalfont}
%\theorempreskipamount 1.5em
%\theoremindent 1em
%\theoremheaderfont{\kern-1em\normalfont\bfseries}
%\newtheorem*{seg}{}

%\newcounter{aufgabe}
%\newenvironment{aufgabe}{\refstepcounter{aufgabe}\par\medskip\noindent%
%	\textbf{Aufgabe \theaufgabe}\rmfamily}
%{\medskip}

